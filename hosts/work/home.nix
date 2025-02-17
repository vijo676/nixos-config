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
    ncdu
    bluetui
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
      online-status
      vim-tmux-navigator
      yank
      resurrect
      continuum
      battery
      cpu
      prefix-highlight
      {
        plugin = catppuccin;
        extraConfig = ''
        '';
      }
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

      # Configure Catppuccin
      set -g @catppuccin_flavor "macchiato"
      set -g @catppuccin_status_background "none"
      set -g @catppuccin_window_status_style "none"
      set -g @catppuccin_pane_status_enabled "off"
      set -g @catppuccin_pane_border_status "off"

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

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_rosewater}"
      set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_peach}"
      set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}]│"

      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"

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
      font-family = "JetBrainsMono NFM";
      font-size = 10;
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
  # catppuccin.flavor = "mocha";
  # catppuccin.enable = true;
  catppuccin.tmux.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
