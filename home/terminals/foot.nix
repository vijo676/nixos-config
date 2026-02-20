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
        colors = {
          alpha = 0.9;
          # Kanagawa Dragon
          foreground = "c5c9c5";
          background = "181616";

          selection-foreground = "C8C093";
          selection-background = "2D4F67";

          regular0 = "0d0c0c";
          regular1 = "c4746e";
          regular2 = "8a9a7b";
          regular3 = "c4b28a";
          regular4 = "8ba4b0";
          regular5 = "a292a3";
          regular6 = "8ea4a2";
          regular7 = "C8C093";

          bright0 = "a6a69c";
          bright1 = "E46876";
          bright2 = "87a987";
          bright3 = "E6C384";
          bright4 = "7FB4CA";
          bright5 = "938AA9";
          bright6 = "7AA89F";
          bright7 = "c5c9c5";

          "16" = "b6927b";
          "17" = "b98d7b";
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
