{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.dank-greeter;
in {
  options.modules.dank-greeter = {
    enable = mkEnableOption "dank-greeter";
  };

  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = mkIf (!cfg.enable) "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    security.pam.services.greetd.gnupg = {
      enable = true;
      noAutostart = true;
    };
  };
}
