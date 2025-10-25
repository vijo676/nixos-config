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
    ../../modules/hyprland
  ];

  # Boot configuration for dual boot with Windows
  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  environment.systemPackages = with pkgs; [
    obs-studio
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.05";
}
