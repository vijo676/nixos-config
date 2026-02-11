{...}: let
in {
  home.username = "vijo";
  home.homeDirectory = "/home/vijo";
  home.stateVersion = "24.11";

  # Import applications modules
  imports = [
    ../../home/default.nix
  ];

  # Enable specific modules
  configured.programs = {
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
    foot.enable = true;
    bash.enable = true;
    zsh.enable = true;
    # desktop
    hyprland = {
      enable = true;
      wallpaper_path = builtins.toPath ../../wallpapers/zen2.jpg;
      monitors_config = [
        "eDP-1, 1920x1200@59.95, 0x1440, 1"
        "DP-2, 2560x1440@164, 0x0,1"
      ];
    };
    rofi.enable = true;
  };

  services.ssh-agent.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
