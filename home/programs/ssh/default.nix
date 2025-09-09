{
  lib,
  config,
  ...
}:
let
  module_name = "ssh";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable SSH";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
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
