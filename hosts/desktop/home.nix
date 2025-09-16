{ pkgs, ... }:
let
in
{
  home.username = "vijo";
  home.homeDirectory = "/home/vijo";
  home.stateVersion = "24.11";

  # Import applications modules
  imports = [
    ../../home/default.nix
  ];

  # Enable specific modules
  configured.programs = {
    zen.enable = true;
    # editors
    vim.enable = true;
    vscode.enable = true;
    zeditor.enable = true;
    # programs
    tmux.enable = true;
    yazi.enable = true;
    starship.enable = true;
    direnv.enable = true;
    fzf.enable = true;
    git.enable = true;
    ssh.enable = true;
    zoxide.enable = true;
    btop.enable = true;
    # shell and terminals
    alacritty.enable = true;
    ghostty.enable = true;
    bash.enable = true;
    zsh.enable = true;
    # desktop
    hyprland = {
      enable = true;
      wallpaper_path = builtins.toPath ../../wallpapers/japan1.png;
      monitors_config = [
        "DP-1, 2560x1440@165, 0x0, 1"
        "DP-2, 2560x1440@164, 2560x0,1"
      ];
    };
    rofi.enable = true;
  };

  # Home packages
  home.packages = with pkgs; [
    xsel
    lazygit
    rust-analyzer
    youtube-music
    tldr
    nmap
    poetry
    ncdu
    bluetui
    ruff
    protobuf
    d-spy
    bruno
    bruno-cli
    pavucontrol
    networkmanagerapplet
    playerctl
    brightnessctl
  ];
  home.file = {
  };
  home.sessionVariables = {
  };
  services.ssh-agent.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
