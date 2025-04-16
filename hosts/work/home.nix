{pkgs, ...}: let
  yazi-flavors = pkgs.fetchFromGitHub {
    owner = "marcosvnmelo";
    repo = "kanagawa-dragon.yazi";
    rev = "main";
    sha256 = "";
  };
in {
  home.username = "vijo";
  home.homeDirectory = "/home/vijo";
  home.stateVersion = "24.11";
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
  # yazi
  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        show_hidden = true;
        show_symlink = true;
        linemode = "permissions";
        title_format = "";
      };
    };
    theme = {
      flavor = {
        dark = "kanagawa-dragon";
      };
    };
  };
  # vscode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      kamadorueda.alejandra
      bbenoist.nix
      jnoortheen.nix-ide
      charliermarsh.ruff
      ms-python.python
      ms-python.vscode-pylance
      rust-lang.rust-analyzer
      vscodevim.vim
      github.copilot
      github.vscode-github-actions
      tamasfe.even-better-toml
      usernamehw.errorlens
      naumovs.color-highlight
      tal7aouy.icons
      jdinhlife.gruvbox
    ];
    userSettings = {
      "rust-analyzer.linkedProjects" = [
        "./apps/rust/barcode/Cargo.toml"
        "./apps/rust/calibration-rs/Cargo.toml"
        "./apps/rust/eol-station-rs/Cargo.toml"
        "./apps/rust/findveo-rs/Cargo.toml"
        "./apps/rust/flashing-station-rs/Cargo.toml"
        "./apps/rust/id-station-rs/Cargo.toml"
        "./apps/rust/init_vc3_labels/Cargo.toml"
        "./apps/rust/lib/ftdi_debug_boards/Cargo.toml"
      ];
      "workbench.colorTheme" = "Kanagawa Dragon";
      "editor.fontFamily" = "NotoSans NF Mono";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.minimap.enabled" = false;
    };
  };
  # vim
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [vim-airline catppuccin-vim vim-closer nvim-treesitter];
    settings = {
      relativenumber = true;
    };
  };
  # ssh
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      Host github.com
        ForwardAgent yes

      Host *.camops.veo.co
        User veo
        ForwardAgent yes
    '';
  };
  services.ssh-agent.enable = true;
  # bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyIgnore = ["ls" "cd" "exit" "ll" "clear" "cl"];
    shellAliases = {
      ll = "lsd -la --date relative";
      c = "clear";
      l = "ls -CF";
      ls = "lsd";
      cd = "z";
      tree = "lsd --tree";
      gs = "git status";
      ".." = "cd ..";
      yz = "yazi";
      lzg = "lazygit";
      man = "batman";
      hmu = "home-manager switch --flake .#work";
      nix-cleanup = "nix-collect-garbage -d";
    };
  };
  # git
  programs.git = {
    enable = true;
    userName = "vijo676";
    userEmail = "vitale.jorgensen@gmail.com";
  };
  # tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    keyMode = "vi";
    prefix = "C-space";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      online-status
      vim-tmux-navigator
      yank
      resurrect
      continuum
      battery
      cpu
      prefix-highlight
      gruvbox
    ];
    extraConfig = ''
      # Enable true color
      set -g default-terminal "tmux-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # Enable focus events
      set -g focus-events on

      # Enable gapeless window
      set -g renumber-windows on

      set-option -g status-right ""
      set -g @continuum-restore 'on'
      set -g @continuum-boot 'on'

      set -g set-clipboard on
      set -g @override_copy_command 'xsel --clipboard --input'
      set -g @yank_selection 'clipboard'
      set -as terminal-features ',*:clipboard'

      bind -Troot C-w switch-client -T VimWindowMovements
      bind -TVimWindowMovements h select-pane -L
      bind -TVimWindowMovements j select-pane -D
      bind -TVimWindowMovements k select-pane -U
      bind -TVimWindowMovements l select-pane -R

      # status left look and feel
      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_maroon}]  #{pane_current_command} "
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

      # status right look and feel
      set -g status-right-length 100
      set -g status-right ""
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "

      # Configure Tmux
      set -g status-style "bg=#{@thm_bg}"
      set -g status-justify "absolute-centre"

      # pane border look and feel
      setw -g pane-border-format ""
      setw -g pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
      setw -g pane-border-style "bg=#{@thm_bg},fg=#{@thm_surface_0}"

      # window look and feel
      set -wg automatic-rename on
      set -g automatic-rename-format "Window"

      # Window status formatting
      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#282828,fg=#a89984"
      set -g window-status-last-style "bg=#282828,fg=#fabd2f"
      set -g window-status-activity-style "bg=#282828,fg=#8b8bb2"
      set -gF window-status-separator "#[bg=#282828,fg=#a89984]│"  # Dark gray separator for subtle contrast

      # Current window formatting (highlighted window)
      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#98971a,fg=#282828,bold"
    '';
  };
  # starship
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  # zoxide
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
  # lsd colors
  programs.lsd = {
    enable = true;
  };
  # bat
  programs.bat = {
    enable = true;
    extraPackages = [pkgs.bat-extras.batman pkgs.bat-extras.prettybat];
  };
  # fzf
  programs.fzf = {
    enable = true;
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];
    defaultOptions = [
      "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    ];
  };
  # direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  # ghostty
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "GruvboxDarkHard";
      font-family = "CaskaydiaCove Nerd Font";
      font-size = 11;
      background-opacity = 0.85;
      background-blur-radius = 0;
      window-decoration = false;
    };
  };
  # btop
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
    };
  };
  # zed editor
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "kanagawa-themes"
      "ruff"
    ];
    userSettings = {
      features = {
        copilot = true;
      };
      vim_mode = true;
      base_keymap = "VSCode";
      theme = {
        mode = "dark";
        dark = "Kanagawa Dragon";
        light = "Kanagawa Dragon";
      };
      shell = "system";
      line_height = "comfortable";
      font_family = "CaskaydiaCove Nerd Font";
      font_size = 15;
      ui_font_size = 15;
      buffer_font_size = 15;
      hour_format = "hour24";
      env = {
        TERM = "xterm-ghostty";
      };
      languages = {
        Python = {
          language_servers = ["ruff"];
          format_on_save = "on";
        };
      };
      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
          initialization_options = {
            linkedProjects = [
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
        };
        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };
    };
  };
  # catppuccin.flavor = "mocha";
  # catppuccin.enable = true;
  # gruvbox.tmux.enable = true;
  # catppuccin.tmux.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
