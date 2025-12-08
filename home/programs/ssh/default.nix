{
  lib,
  config,
  ...
}: let
  module_name = "ssh";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable SSH";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = true;
        addKeysToAgent = "yes";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      extraConfig = ''
        Host vc3-*
          User root
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null
          ForwardAgent yes

        Host github.com
          ForwardAgent yes

        Host *.camops.veo.co
          User veo
          ForwardAgent yes
      '';
    };
  };
}
