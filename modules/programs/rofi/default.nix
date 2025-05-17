{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "rofi";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Rofi App Launcher";
    theme_path = lib.mkOption {
        type = lib.types.path;
        default = builtins.toPath ./dark_default.rasi;
        description = "path to the rasi rofi theme";
    };
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      theme = cfg.theme_path;
    };
  };
}
