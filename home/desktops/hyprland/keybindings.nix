{...}: {
  "$mod" = "SUPER";
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
  bindl = [
    # switch toggled
    ", switch:Lid Switch, exec, hyprlock"
    # switch is turning on
    ", switch:on:Lid Switch, exec, hyprctl keyword monitor eDP-1, disable"
    # switch is turning off
    ", switch:off:Lid Switch, exec, hyprctl keyword monitor eDP-1, preferred, 0x0, 1"
  ];
  bind =
    [
      "$mod, F1, exec, show-keybinds"
      "$mod, q, killactive"
      "$mod, b, exec, firefox"
      "$mod, RETURN, exec, ghostty"
      "$mod, d, exec, rofi -show drun || pkill rofi"
      "$mod, v, togglefloating"
      "$mod, f, fullscreen"
      "$mod, e, exec, nautilus"
      "$mod, ESCAPE, exec, hyprlock"
      "$mod, s, exec, hyprshot -m region"
      "$mod SHIFT, s, exec, hyprshot -m window"
      # Screenshot a monitor
      ", PRINT, exec, hyprshot -m output"

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

      # Switch between windows in a floating workspace
      "$mod, Tab, cyclenext"
      "$mod, Tab, bringactivetotop"

      # Scroll through existing workspaces with mainMod + scroll
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
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
}
