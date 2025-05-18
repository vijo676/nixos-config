{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  module_name = "hyprland";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Hyprland configuration";
    wallpaper_path = lib.mkOption {
      type = lib.types.path;
      default = builtins.toPath ../../../wallpapers/japanese_pedestrian_street.png;
      description = "path to the wallpaper";
    };
    monitors_config = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of the monitor configurations";
      example = ["DP-1, 1920x1080, 0x0, 1" "DP-2, 1920x1080, 1920x0, 1"];
    };
  };
  config = mkIf cfg.enable {
    # Notification daemon
    services.dunst = {
      enable = true;
    };
    # Wallpaper
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;
        preload = [cfg.wallpaper_path];
        wallpaper = ", ${cfg.wallpaper_path}";
      };
    };
    # Themes
    gtk = {
      enable = true;
      theme = {
        package = pkgs.kanagawa-gtk-theme;
        name = "Kanagawa";
      };
      iconTheme = {
        package = pkgs.kanagawa-icon-theme;
        name = "Kanagawa";
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 25;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
    };
    wayland.windowManager.hyprland.systemd.variables = ["--all"];
    wayland.windowManager.hyprland.plugins = [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    wayland.windowManager.hyprland.extraConfig = "

        monitor = , preferred, auto, 1

        $terminal = xterm-ghostty

        binds {
            workspace_back_and_forth = 1
            #allow_workspace_cycles=1
            #pass_mouse_when_bound=0
        }

    ";
    wayland.windowManager.hyprland.settings =
      {
        ##################
        ### AUTOSTART ###
        #################

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "waybar"
          "hyprpaper"
          "hypridle"
          # "hyprpm reload -n"
        ];

        ################
        ### MONITORS ###
        ################

        monitor = cfg.monitors_config;

        #############################
        ### ENVIRONMENT VARIABLES ###
        #############################

        env = [
          "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
          "MOZ_WEBRENDER, 1" # for firefox to run on wayland
          "EDITOR, vim"

          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"

          "GDK_BACKEND,wayland,x11,*"
          "NIXOS_OZONE_WL,1"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "MOZ_ENABLE_WAYLAND,1"
          "OZONE_PLATFORM,wayland"
          "EGL_PLATFORM,wayland"
          "CLUTTER_BACKEND,wayland"
          "SDL_VIDEODRIVER,wayland"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "WLR_RENDERER_ALLOW_SOFTWARE,1"
          "NIXPKGS_ALLOW_UNFREE,1"
        ];

        #############
        ### INPUT ###
        #############

        input = {
          kb_layout = "us,dk";
          kb_options = "grp:alt_caps_toggle";
          repeat_delay = 300;
          sensitivity = 0;
          force_no_accel = true;
          follow_mouse = 1;
        };
      }
      // (import ./keybindings.nix {inherit pkgs;})
      // (import ./style.nix);
  };
  imports = [
    ../../programs/waybar
    (import ./hyprlock.nix {inherit pkgs cfg;})
    (import ./hypridle.nix {inherit pkgs;})
  ];
}
