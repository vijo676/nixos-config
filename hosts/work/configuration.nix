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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
