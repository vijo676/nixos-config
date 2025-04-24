{pkgs, ...}: let
in {
  home.username = "vijo";
  home.homeDirectory = "/home/vijo";
  home.stateVersion = "24.11";

  # Import applications modules
  imports = [
    ../../modules/default.nix
  ];

  # Enable specific modules
  configured.programs = {
    vim.enable = true;
    vscode.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };

  # Home packages
  home.packages = with pkgs; [
    xsel
    tmux
    zoxide
    bat
    fzf
    oh-my-posh
    lsd
    lazygit
    zed-editor
    rust-analyzer
    youtube-music
    btop
    tldr
    nmap
    librewolf
    poetry
    ncdu
    bluetui
    ruff
    protobuf
    d-spy
    bruno
    bruno-cli
  ];
  home.file = {
  };
  home.sessionVariables = {
  };
  services.ssh-agent.enable = true;
  # btop
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
