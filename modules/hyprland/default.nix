{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
  security.pam.services.hyprlock = {};
}
