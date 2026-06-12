{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "yazi";
  kanagawa-paper-yazi = (
    pkgs.fetchFromGitHub {
      owner = "melindachang";
      repo = "kanagawa-paper.yazi";
      rev = "7f3cd1d8a579cc8a38fca67fcb3cb018e4d7171c";
      hash = "sha256-QSDcHvQwUABGM76OYW2rrFcSkpo/q7e0bBZLbpCIiqw=";
    }
  );
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Yazi FileManager";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
      plugins = {
        bypass = pkgs.yaziPlugins.bypass;
        git = pkgs.yaziPlugins.git;
        lazygit = pkgs.yaziPlugins.lazygit;
        mediainfo = pkgs.yaziPlugins.mediainfo;
        piper = pkgs.yaziPlugins.piper;
        vcs-files = pkgs.yaziPlugins.vcs-files;
      };

      settings = {
        mgr = {
          sort_dir_first = true;
          show_hidden = true;
          show_symlink = true;
          linemode = "size";
          title_format = "";
          ratio = [
            1
            3
            4
          ];
        };
        preview = {
          wrap = "yes";
          tab_size = 4;
          max_width = 1920;
          max_height = 1080;
          image_quality = 90;
        };
        plugin = {
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              on = ["e"];
              run = "vim ";
            }
            {
              on = ["d"];
              run = "remove --force";
            }
            {
              on = [
                "g"
                "c"
              ];
              run = "plugin vcs-files";
              desc = "Show Git file changes";
            }
            {
              on = [
                "g"
                "i"
              ];
              run = "plugin lazygit";
              desc = "run lazygit";
            }
          ];
        };
      };
      flavors = {
        kanagawa-paper = "${kanagawa-paper-yazi}";
      };
      theme = {
        flavor = {
          dark = "kanagawa-paper";
          light = "kanagawa-paper";
        };
        status = {
          separator_open = "";
          separator_close = "";
        };
      };
    };
  };
}
