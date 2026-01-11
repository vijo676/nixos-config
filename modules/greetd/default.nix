{pkgs, ...}: let
in {
  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
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
