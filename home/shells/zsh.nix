{
  lib,
  config,
  ...
}: let
  module_name = "zsh";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        ignoreDups = true;
        ignoreSpace = true;
      };

      historySubstringSearch.enable = true;

      shellAliases = {
        ls = lib.mkForce "eza --oneline --group-directories-first --show-symlinks";
        lsa = lib.mkForce "ls --all";
        ll = lib.mkForce "ls --long --all --changed";
        ff = "fzf --preview 'bat --style=numbers --color=always {}'";
        env = "env | tspin";
        cd = "z";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        yz = "yazi";
        lzg = "lazygit";
        lzj = "lazyjj";
        man = "batman";
        gs = "git status";
        nix-cleanup = "nix-collect-garbage -d";
      };
      plugins = [
      ];

      initContent = ''
        # Zsh options
        setopt AUTO_CD              # cd by typing directory name if it's not a command
        setopt CORRECT_ALL          # autocorrect commands
        setopt SHARE_HISTORY        # share history between shells
        setopt HIST_VERIFY          # show command with history expansion to user before running it

        # Key bindings
        bindkey '^P' up-line-or-history      # Ctrl+P for previous command
        bindkey '^N' down-line-or-history    # Ctrl+N for next command
        bindkey '^L' autosuggest-accept      # Ctrl+L accept autosuggestion
        bindkey '^A' vi-beginning-of-line
        bindkey '^E' vi-end-of-line
        bindkey '^B' vi-backward-word
        bindkey '^W' vi-forward-word


        export TERM=xterm-256color
      '';
    };
  };
}
