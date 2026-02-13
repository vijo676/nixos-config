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
    jujutsu.enable = true;
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
      wallpaper_path = builtins.toPath ../../wallpapers/japan2.jpg;
      monitors_config = [
        "DP-1, 2560x1440@165, 0x0, 1, bitdepth,10"
        "DP-2, 2560x1440@164, 2560x0,1"
      ];
    };
    niri = {
      enable = true;
      monitors_config = ''
        output "DP-1" {
                mode "2560x1440@165"
                scale 1
                transform "normal"
                position x=0 y=0
            }
        output "DP-2" {
                mode "2560x1440@165"
                scale 1
                transform "90"
                position x=2560 y=-400
            }
      '';
    };
    rofi.enable = true;
  };

  home.file = {
  };
  home.sessionVariables = {
  };
  services.ssh-agent.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
