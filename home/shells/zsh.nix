{
  pkgs,
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
        man = "batman";
        gs = "git status";
        nix-cleanup = "nix-collect-garbage -d";
      };
      plugins = [
        # {
        #   name = "vi-mode";
        #   src = pkgs.zsh-vi-mode;
        #   file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        # }
      ];

      initContent = ''
        # Zsh options
        setopt AUTO_CD              # cd by typing directory name if it's not a command
        setopt CORRECT_ALL          # autocorrect commands
        setopt SHARE_HISTORY        # share history between shells
        setopt HIST_VERIFY          # show command with history expansion to user before running it

        # Make Ctrl+L accept autosuggestion
        bindkey '^L' autosuggest-accept
      '';
    };
  };
}
