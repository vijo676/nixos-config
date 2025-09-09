{
  pkgs,
  lib,
  config,
  ...
}:
let
  module_name = "git";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "vijo676";
      userEmail = "vitale.jorgensen@gmail.com";
    };
  };
}
