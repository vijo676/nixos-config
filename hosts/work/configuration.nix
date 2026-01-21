{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/hyprland
    ../../home/desktops/hyprland/scripts/edot.nix
    inputs.neovim.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Neovim
  programs.neovim-monica = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    colorschemePackage = pkgs.vimPlugins.gruvbox-material;
    colorschemeName = "gruvbox-material";
  };

  # Udev rules
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
  '';

  # Networking
  networking.hostName = "work";
  networking.firewall.trustedInterfaces = ["enp195s0f3u2"];

  # System wide packages
  environment.systemPackages = with pkgs; [
    _1password-gui-beta
    pkg-config
    marktext
  ];

  system.stateVersion = "24.11";
}
