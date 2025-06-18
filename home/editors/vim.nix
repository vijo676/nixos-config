{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "vim";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Vim";
  };

  config = mkIf cfg.enable {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
        catppuccin-vim
        vim-closer
        nvim-treesitter
      ];
      settings = {
        relativenumber = true;
      };
    };
  };
}
