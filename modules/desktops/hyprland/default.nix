{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./binds.nix
    ./settings.nix
  ];

  home.packages = with pkgs; [
    swaybg
  ];

  wayland.windowManager.hyprland = {
    enable = true;
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}
