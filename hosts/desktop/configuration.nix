{
  pkgs,
  lib,
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
    ../../modules/dank-greeter
    ../../modules/hyprland
  ];

  modules.dank-greeter.enable = true;

  boot.supportedFilesystems = ["ntfs"];

  environment.systemPackages = with pkgs; [
    obs-studio
    sbctl
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.05";
}
