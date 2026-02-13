{
  lib,
  config,
  ...
}: let
  module_name = "jujutsu";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Jujutsu git compaticable DVCS";
  };

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      settings.user.name = "vijo676";
      settings.user.email = "vitale.jorgensen@gmail.com";
    };
  };
}
