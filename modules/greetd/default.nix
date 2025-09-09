{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = "Hyprland -c ${pkgs.nwg-hello}/bin/nwg-hello";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        # command = "${pkgs.hyprland}/bin/Hyprland -c ${pkgs.nwg-hello}/etc/nwg-hello/hyprland.conf";
        user = "greeter";
      };
    };
  };
  security.pam.services.greetd.gnupg = {
    enable = true;
    noAutostart = true;
  };
}
