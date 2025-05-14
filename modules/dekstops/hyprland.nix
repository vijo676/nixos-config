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
  };

  config = mkIf cfg.enable {
    # Check if Hyprland is enabled in the host configuration
    assertions = [
      {
        assertion = config.programs.hyprland.enable;
        message = "Hyprland must be enabled in the host configuration (programs.hyprland.enable = true) to use this module.";
      }
    ];

    # Display Manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Kitty is required for the default Hyprland config
    programs.kitty.enable = {
      enable = true;
    };
    # Hints the electron apps to use wayland
    home.sessionVariables.NIXOS_OZONE_WL = "1";
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      # Bindings
      "$mod" = "SUPER";
      bind =
        [
          "$mod, B, exec, firefox"
          "$mod, E, exec, ghostty"
          "$mod, E, exec, rofi -show drun"
          "$mod, V, togglefloating"
          "$mod, F, fullscreen"

          # Move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Move active window
          "$mod, SHIFT, left, movewindow, l"
          "$mod, SHIFT, right, movewindow, r"
          "$mod, SHIFT, up, movewindow, u"
          "$mod, SHIFT, down, movewindow, d"
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
