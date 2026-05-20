{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/niri
    inputs.neovim.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Neovim
  programs.neovim-monica = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    colorschemePackage = pkgs.vimPlugins.everforest;
    colorschemeName = "everforest";
  };

  # Udev rules
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04f9", ATTRS{idProduct}=="209b", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7c18", MODE="0666"
  '';
  networking.firewall.interfaces."usb+".allowedUDPPorts = [67];
  networking.networkmanager.ensureProfiles.profiles.usb-dhcp = {
    connection = {
      id = "usb-dhcp";
      type = "ethernet";
      autoconnect = true;
    };
    match = {
      driver = "cdc_ether";
      interface-name = "usb*";
    };
    ipv4 = {
      method = "shared";
      address1 = "10.42.0.1/24";
    };
  };

  # Tailscale for remote access
  services.tailscale.enable = true;

  # Networking
  networking.hostName = "work";
  networking.firewall.trustedInterfaces = ["enp195s0f3u2"];

  # System wide packages
  environment.systemPackages = with pkgs; [
    _1password-gui-beta
    pkg-config
  ];

  system.stateVersion = "24.11";
}
