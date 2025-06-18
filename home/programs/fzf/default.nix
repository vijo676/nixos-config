{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "fzf";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable FZF and BAT and LSD colors";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      changeDirWidgetOptions = [
        "--preview 'tree -C {} | head -200'"
      ];
      defaultOptions = [
        # "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
      ];
    };
    programs.bat = {
      enable = true;
      extraPackages = [pkgs.bat-extras.batman pkgs.bat-extras.prettybat];
    };
    programs.lsd = {
      enable = true;
    };
  };
}
