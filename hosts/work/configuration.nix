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
    ../../modules/greetd
    ../../modules/hyprland
    ../../home/desktops/hyprland/scripts/edot.nix
  ];

  # Udev rules
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
  '';

  # Networking
  networking.hostName = "vj-work";
  networking.firewall.trustedInterfaces = ["enp195s0f3u2"];

  # System wide packages
  environment.systemPackages = with pkgs; [
    _1password-gui-beta
    pkg-config
    marktext
  ];
  
  system.stateVersion = "24.11";
}
