{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/steam
    # ../../modules/hyprland
    ../../modules/niri
  ];

  boot.supportedFilesystems = ["ntfs"];

  environment.systemPackages = with pkgs; [
    obs-studio
    sbctl
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.05";
}
