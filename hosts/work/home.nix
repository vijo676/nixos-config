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
    zeditor = {
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
    ghostty.enable = true;
    bash.enable = true;

    # desktop
    hyprland = {
      enable = true;
      wallpaper_path = builtins.toPath ../../wallpapers/space2.png;
      monitors_config = ["DP-2, 3840x2160@60,0x0,1" "HDMI-A-1, 3840x2160@60,3840x0,1, transform,1"];
    };
    rofi.enable = true;
  };

  # Home packages
  home.packages = with pkgs; [
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

  programs.home-manager.enable = true;
}
