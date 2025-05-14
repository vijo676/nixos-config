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
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      theme = "gruvbox-dark";
      extraOptions = [
        "-show drun"
        "-modi drun,run"
      ];
    };
  };
}
