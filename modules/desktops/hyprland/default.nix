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
      type = lib.types.str;
      default = "../../../wallpapers/japanese_pedestrian_street.png";
      description = "path to the wallpaper";
    };
    monitors_config = lib.mkOption{
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of the monitor configurations";
      example = ["DP-1, 1920x1080, 0x0, 1" "DP-2, 1920x1080, 1920x0, 1"];
    };
  };
  config = mkIf cfg.enable {
    # Kitty is required for the default Hyprland config
    programs.kitty = {
      enable = true;
    };
    # hyprpaper
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
    # Theme
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
    };
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.volantes-cursors;
      name = "volantes-cursors";
      size = 24;
    };

    # Lock screen
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = false;
          no_fade_in = false;
        };
        background = [
            {
            path = "${cfg.wallpaper_path}";
            blur_passes = 2;
            blur_size = 2;
            }
        ];
      };
    };

    # Idle Daemon
      services.hypridle.enable = true;
      services.hypridle.settings = {
        general = {
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = 360;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
        ];
      };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.plugins = [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    wayland.windowManager.hyprland.extraConfig = "
        monitor = , preferred, auto, 1
    ";
    wayland.windowManager.hyprland.settings = {
      # Auto start
      exec-once = [
        "hyprpaper"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      # Monitors
      monitor = cfg.monitors_config;

      # Env variables
      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
      ];

      input = {
        kb_layout = "us,dk";
        kb_options = "grp:alt_caps_toggle";
        repeat_delay = 300;
        sensitivity = 0;
      };

      decoration = {
        rounding = 10;
        shadow = {
          enabled = false;
          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
          color = "rgba(00000055)";
        };
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
        };
      };

      animations = {
        enabled = true;
      };

      # Bindings
      "$mod" = "SUPER";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind =
        [
          "$mod, F1, exec, show-keybinds"
          "$mod, q, killactive"
          "$mod, b, exec, firefox"
          "$mod, e, exec, ghostty"
          "$mod, d, exec, rofi -show drun || pkill rofi"
          "$mod, v, togglefloating"
          "$mod, f, fullscreen"
          "$mod, Escape, exec, swaylock"
          "ALT, Escape, exec, hyperlock"

          # Move focus
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Move active window
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };
}
