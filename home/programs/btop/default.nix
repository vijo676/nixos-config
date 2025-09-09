{
  pkgs,
  lib,
  config,
  ...
}:
let
  module_name = "btop";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Btop";
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
      };
    };
  };
}
