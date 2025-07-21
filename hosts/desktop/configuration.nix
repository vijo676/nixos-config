{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ../../modules/base {
      inherit pkgs lib;
      username = "vijo";
    })
    ../../modules/steam
    ../../modules/greetd
    ../../modules/hyprland
  ];

  environment.systemPackages = with pkgs; [
    obs-studio
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.05";
}
