{pkgs, ...}: {
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
    firefox
    poetry
  ];
  home.file = {
  };
  home.sessionVariables = {
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
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_status_background "none"
          set -g @catppuccin_pane_status_enabled "off"
          set -g @catppuccin_pane_border_status "off"
          set -g @catppuccin_status_background "none"
        '';
      }
      yank
      resurrect
      continuum
      battery
      cpu
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
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;
  catppuccin.tmux.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
