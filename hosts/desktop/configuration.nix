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

  # Udev rules
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04f9", ATTRS{idProduct}=="209b", MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    obs-studio
    sbctl
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.05";
}
