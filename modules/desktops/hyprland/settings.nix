{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    # Auto start
    exec-once = [
      "swaybg -i ${../../wallpapers/japanese_pedestrian_street.png} -m fill&"
    ];

    input = {
      kb_layout = "us,dk";
      kb_options = "grp:alt_caps_toggle";
      repeat_delay = 300;
      sensitivity = 0;
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
            path = "wallpapers";
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
    decoration = {
      rounding = 0;
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
  };
}
