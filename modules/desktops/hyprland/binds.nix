let
in {
  wayland.windowManager.hyprland.settings = {
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
}
