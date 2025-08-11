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
        ll = lib.mkForce "lsd -la --date relative";
        c = "clear";
        l = "ls -CF";
        ls = lib.mkForce "lsd";
        cd = "z";
        tree = "lsd --tree";
        gs = "git status";
        ".." = "cd ..";
        yz = "yazi";
        lzg = "lazygit";
        man = "batman";
        nix-cleanup = "nix-collect-garbage -d";
      };

      initContent = ''
        # Zsh options
        setopt AUTO_CD              # cd by typing directory name if it's not a command
        setopt CORRECT_ALL          # autocorrect commands
        setopt SHARE_HISTORY        # share history between shells
        setopt HIST_VERIFY          # show command with history expansion to user before running it

        # Key bindings
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        # History substring search bindings
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
      '';
    };
  };
}
