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
    niri = {
      enable = true;
      monitors_config = ''
      '';
    };
  };

  services.ssh-agent.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
