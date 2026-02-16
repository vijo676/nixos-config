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
    # ../../modules/hyprland
    ../../modules/niri
    inputs.neovim.nixosModules.default
  ];
  # Neovim
  programs.neovim-monica = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    colorschemePackage = pkgs.vimPlugins.kanagawa-paper-nvim;
    colorschemeName = "kanagawa-paper";
  };

  boot.supportedFilesystems = ["ntfs"];

  environment.systemPackages = with pkgs; [
    obs-studio
    sbctl
  ];

  networking.hostName = "desktop";
  system.stateVersion = "25.05";
}
