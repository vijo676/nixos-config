{
  pkgs,
  lib,
  config,
  # inputs,
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
    services.xsettingsd.enable = true;
    gtk = {
      enable = true;
      font.name = "Caskaydia Cove Nerd Font";
      font.size = 11;
      theme = {
        package = pkgs.everforest-gtk-theme;
        name = "Everforest-Dark-BL";
      };
      iconTheme = {
        package = pkgs.everforest-gtk-theme;
        name = "Everforest-Dark";
      };
      gtk2.extraConfig = "
        gtk-application-prefer-dark-theme=1
      ";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };
    };
    qt.style.name = "Everforest-Dark-BL";
    home.sessionVariables.GTK_THEME = "Everforest-Dark-BL";
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 25;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      package = null;
      portalPackage = null;
    };
    wayland.windowManager.hyprland.systemd.variables = ["--all"];
    wayland.windowManager.hyprland.plugins = [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    wayland.windowManager.hyprland.extraConfig = "
    monitor= , preferred, auto, 1

    $terminal=xterm-ghostty

    binds {
        workspace_back_and_forth=1
        #allow_workspace_cycles=1
        #pass_mouse_when_bound=0
    }

    device {
      name=logitech-mx-master-3s
      sensitivity=0.0
    }
    ";
    wayland.windowManager.hyprland.settings =
      {
        ##################
        ### AUTOSTART ###
        #################

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "hyprpaper"
          "hypridle"
          "sleep 1 && systemctl --user restart waybar.service" # Delayed waybar start for NVIDIA
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
          "GTK_USE_PORTAL,1"
          "NIXOS_XDG_OPEN_USE_PORTAL,1"

          "GDK_BACKEND,wayland,x11,*"
          "NIXOS_OZONE_WL,1"
          "BROWSER,firefox"

          "MOZ_ENABLE_WAYLAND,1"
          "OZONE_PLATFORM,wayland"
          "EGL_PLATFORM,wayland"
          "CLUTTER_BACKEND,wayland"
          "SDL_VIDEODRIVER,wayland"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_QPA_PLATFORMTHEME,gtk3"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "WLR_RENDERER_ALLOW_SOFTWARE,1"
          "NIXPKGS_ALLOW_UNFREE,1"
          "HYPRSHOT_DIR,${config.home.homeDirectory}/Pictures"
        ];

        #############
        ### INPUT ###
        #############

        input = {
          kb_layout = "us,dk";
          kb_options = "grp:alt_caps_toggle";
          repeat_delay = 300;
          sensitivity = 0;
          # force_no_accel = true;
          follow_mouse = 1;
        };
      }
      // (import ./keybindings.nix {inherit pkgs;})
      // (import ./style.nix);
  };
  imports = [
    ../../programs/waybar
    (import ../../programs/dunst {inherit pkgs;})
    (import ./hyprlock.nix {inherit pkgs cfg;})
    (import ./hypridle.nix {inherit pkgs;})
    (import ./wlogout.nix {inherit pkgs;})
  ];
}
