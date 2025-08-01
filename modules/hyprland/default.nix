{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    # xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gnome];
    config.common = {
      default = ["gnome" "hyprland" "gtk"];
      "org.freedesktop.impl.portal.Settings" = "gnome";
    };
  };
  security.pam.services.hyprlock = {};
}
