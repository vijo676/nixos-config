{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  module_name = "zen";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [ inputs.zen-browser.homeModules.twilight ];
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Zen Browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
    };
  };
}
