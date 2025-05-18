{
  pkgs,
  lib,
  config,
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

    # Lock screen
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 0;
          disable_loading_bar = true;
          hide_cursor = false;
          no_fade_in = false;
        };
        background = [
          {
            monitor = "";
            path = "${cfg.wallpaper_path}";
            blur_passes = 2;
            blur_size = 2;
          }
        ];
        input-field = {
          monitor = "";
          size = "300, 40";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(76, 86, 106, 0.1)";
          font_color = "rgb(191, 186, 159)";
          fade_on_empty = false;
          font_family = "CaskaydiaCove Nerd Font";
          fail_color = "rgb(237, 135, 150)";
          placeholder_text = "Password...";
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
        };
        label = {
          monitor = "";
          text = "$TIME";
          color = "rgb(191, 186, 159)";
          font_family = "Caskaydia Cove Nerd Font Bold";
          font_size = 64;
          position = "0, 300";
          halign = "center";
          valign = "center";
        };
      };
    };

    # Idle Daemon
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          unlock_cmd = "pkill --signal SIGUSR1 hyprlock";
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 300; # 5 mins
            on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = 360; # 6 mins
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
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
          "waybar"
          "hyprpaper"
          "hypridle"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
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
  ];
}
