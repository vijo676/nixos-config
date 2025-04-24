{
  lib,
  config,
  username,
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
    home-manager.users.${username} = {
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
  };
}
