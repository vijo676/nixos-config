{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "bash";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyIgnore = ["ls" "cd" "exit" "ll" "clear" "cl"];
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
      bashrcExtra = ''
        export TERM=xterm-256color
      '';
    };
  };
}
