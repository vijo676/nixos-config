{
  pkgs,
  inputs,
  ...
}: {
  programs.niri = {
    enable = true;
  };
  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };
  security.pam.services.greetd.gnupg = {
    enable = true;
    noAutostart = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${system}.default
    xwayland-satellite # Needed for Niri's XWayland support
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = ["gtk"];
      };
      niri = {
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
      };
    };
  };

  home-manager.extraSpecialArgs = {
    imports = [
      inputs.noctalia.homeModules.default
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
  };

  security.pam.services.niri = {};
}
