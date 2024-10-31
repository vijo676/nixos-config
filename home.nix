{
  config,
  pkgs,
  ...
}: {
  home.username = "vijo";
  home.homeDirectory = "/home/vijo";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    vim
    tmux
    zoxide
    bat
    fzf
    oh-my-posh
    lsd
    lazygit
  ];
  home.file = {
  };
  home.sessionVariables = {
  };
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
        '';
      }
    ];
    extraConfig = ''
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
  };
  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [
      "--preview 'bat --color=always {}'"
      "--preview-window '~3'"
    ];
  };
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;
  programs.tmux.catppuccin.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
