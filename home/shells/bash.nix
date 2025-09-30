{
  lib,
  config,
  ...
}:
let
  module_name = "bash";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyIgnore = [
        "ls"
        "cd"
        "exit"
        "ll"
        "clear"
      ];
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
      bashrcExtra = ''
        export TERM=xterm-256color
      '';
    };
  };
}
