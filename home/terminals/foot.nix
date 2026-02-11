{
  lib,
  config,
  ...
}: let
  module_name = "foot";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Alacritty";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "CaskaydiaCove Nerd Font:size=11";
          dpi-aware = "yes";
        };
      };
    };
    programs.eza = {
      enable = true;
      colors = "always";
      icons = "always";
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
