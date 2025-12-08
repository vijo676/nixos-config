{
  lib,
  config,
  ...
}: let
  module_name = "git";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user.name = "vijo676";
      settings.user.email = "vitale.jorgensen@gmail.com";
    };
  };
}
