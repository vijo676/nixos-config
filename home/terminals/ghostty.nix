{
  lib,
  config,
  ...
}: let
  module_name = "ghostty";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Ghostty";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "GruvboxDarkHard";
        font-family = "CaskaydiaCove Nerd Font";
        font-size = 11;
        background-opacity = 0.55;
        background-blur-radius = 0;
        window-decoration = false;
        cursor-style = "block";
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
