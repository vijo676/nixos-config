{pkgs, ...}: let
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
    zen.enable = true;
    # editors
    vim.enable = true;
    vscode = {
      enable = true;
      rustAnalyzerLinkedProjects = [
        "./apps/rust/barcode/Cargo.toml"
        "./apps/rust/calibration-rs/Cargo.toml"
        "./apps/rust/eol-station-rs/Cargo.toml"
        "./apps/rust/findveo-rs/Cargo.toml"
        "./apps/rust/flashing-station-rs/Cargo.toml"
        "./apps/rust/id-station-rs/Cargo.toml"
        "./apps/rust/init_vc3_labels/Cargo.toml"
        "./apps/rust/lib/ftdi_debug_boards/Cargo.toml"
      ];
    };
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
      wallpaper_path = builtins.toPath ../../wallpapers/japan2.jpg;
      monitors_config = [
        "DP-1, 2560x1440@165, 0x0, 1, bitdepth,10"
        "DP-2, 2560x1440@164, 2560x0,1"
      ];
    };
    rofi.enable = true;
  };

  # Home packages
  home.packages = with pkgs; [
  ];
  home.file = {
  };
  home.sessionVariables = {
  };
  services.ssh-agent.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
