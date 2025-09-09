{
  pkgs,
  lib,
  config,
  ...
}:
let
  module_name = "fzf";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable FZF and BAT";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
      ];
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
