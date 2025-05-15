{
  general = {
    gaps_in = 4;
    gaps_out = 9;
    border_size = 2;
    "col.active_border" = "rgba(81a1c1ff)";
    "col.inactive_border" = "rgba(4c566aff)";
    # "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
    # "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
    resize_on_border = true;
    layout = "dwindle"; # dwindle or master
    # allow_tearing = true; # Allow tearing for games (use immediate window rules for specific games or all titles)
  };

  decoration = {
    rounding = 10;
    shadow.enabled = false;
    blur = {
      enabled = true;
      size = 6;
      passes = 2;
      brightness = 1;
      contrast = 1.4;
      noise = 0;
      ignore_opacity = true;
      new_optimizations = true;
      xray = false;
    };
  };

  group = {
    "col.border_active" = "rgba(81a1c1ff)";
    "col.border_inactive" = "rgba(4c566aff)";
    # "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
    # "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
    # "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
    # "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
  };

  layerrule = [
    "blur, rofi"
    "ignorezero, rofi"
    "ignorealpha 0.7, rofi"

    # "blur, swaync-control-center"
    # "blur, swaync-notification-window"
    # "ignorezero, swaync-control-center"
    # "ignorezero, swaync-notification-window"
    # "ignorealpha 0.7, swaync-control-center"
    # "ignorealpha 0.8, swaync-notification-window"
    # "dimaround, swaync-control-center"
  ];

  animations = {
    enabled = true;
    bezier = [
    "linear, 0, 0, 1, 1"
    "md3_standard, 0.2, 0, 0, 1"
    "md3_decel, 0.05, 0.7, 0.1, 1"
    "md3_accel, 0.3, 0, 0.8, 0.15"
    "overshot, 0.05, 0.9, 0.1, 1.1"
    "crazyshot, 0.1, 1.5, 0.76, 0.92"
    "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
    "fluent_decel, 0.1, 1, 0, 1"
    "easeInOutCirc, 0.85, 0, 0.15, 1"
    "easeOutCirc, 0, 0.55, 0.45, 1"
    "easeOutExpo, 0.16, 1, 0.3, 1"
    ];
    animation = [
    "windows, 1, 3, md3_decel, popin 60%"
    "border, 1, 10, default"
    "fade, 1, 2.5, md3_decel"
    # "workspaces, 1, 3.5, md3_decel, slide"
    "workspaces, 1, 3.5, easeOutExpo, slide"
    # "workspaces, 1, 7, fluent_decel, slidefade 15%"
    # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
    "specialWorkspace, 1, 3, md3_decel, slidevert"
    ];
  };

  render = {
    explicit_sync = 2; # 0 = off, 1 = on, 2 = auto based on gpu driver.
    explicit_sync_kms = 2; # 0 = off, 1 = on, 2 = auto based on gpu driver.
    direct_scanout = 2; # 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
  };

  misc = {
    disable_hyprland_logo = true;
    mouse_move_focuses_monitor = true;
    swallow_regex = "^(xterm-ghostty|kitty)$";
    enable_swallow = true;
    vfr = true; # always keep on
    vrr = 1; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only)
  };

  gestures = {
    workspace_swipe = true;
    workspace_swipe_fingers = 3;
  };

  windowrule = [
    "opacity 1.00 1.00,class:^(firefox)$"
    "opacity 0.80 0.80,class:^(Spotify)$"
    "opacity 0.80 0.80,class:^(code)$"
    "opacity 0.80 0.80,class:^(zeditor)$"
  ];
}
