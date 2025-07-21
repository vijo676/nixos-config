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

  networking.hostName = "nixos-desktop";
  system.stateVersion = "25.05";
}
