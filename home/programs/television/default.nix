{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "television";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable television";
  };

  config = mkIf cfg.enable {
    programs.television = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        tick_rate = 50;
        default_channel = "files";
        ui = {
          use_nerd_font_icons = true;
          ui_scale = 100;
          theme = "gruvbox-dark";
          orientation = "landscape";
        };
        keybindings = {
          esc = "quit";
          ctrl-c = "quit";
          ctrl-t = "toggle_layout";
        };
      };
    };
    programs.bat = {
      enable = true;
      extraPackages = [
        pkgs.bat-extras.batman
        pkgs.bat-extras.prettybat
      ];
    };
  };
}
