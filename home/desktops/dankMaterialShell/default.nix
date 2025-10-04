{
  lib,
  config,
  inputs,
  ...
}: let
  module_name = "dankMaterialShell";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Dank Material Shell configuration";
  };
  config = mkIf cfg.enable {
    programs.dankMaterialShell.enable = true;
  };
  imports = [inputs.dankMaterialShell.homeModules.dankMaterialShell.default];
}
