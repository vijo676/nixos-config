{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/steam
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

  boot.supportedFilesystems = ["ntfs"];
  boot.blacklistedKernelModules = ["lpvo_usb_gpib"];

  # Udev rules
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04f9", ATTRS{idProduct}=="209b", MODE="0666"

    # Jetson
    SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7c18", MODE="0666"
    SUBSYSTEM=="net", ACTION=="add", ENV{ID_USB_DRIVER}=="cdc_ether", ENV{ID_USB_VENDOR}=="NVIDIA", ENV{ID_USB_MODEL}=="Linux_for_Tegra", NAME="jetson%n"
  '';

  networking.firewall.interfaces."jetson+".allowedUDPPorts = [67];
  networking.networkmanager.ensureProfiles.profiles.usb-dhcp = {
    connection = {
      id = "usb-dhcp";
      type = "ethernet";
      autoconnect = true;
      multi-connect = "3";
    };
    match = {
      driver = "cdc_ether";
      interface-name = "jetson*";
    };
    ipv4 = {
      method = "shared";
      address1 = "10.42.0.1/24";
    };
  };

  environment.systemPackages = with pkgs; [
    obs-studio
    sbctl
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.05";
}
