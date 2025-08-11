{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  module_name = "yazi";
  kanagawa-yazi = (
    pkgs.fetchFromGitHub {
      owner = "marcosvnmelo";
      repo = "kanagawa-dragon.yazi";
      rev = "49055274ff53772a13a8c092188e4f6d148d1694";
      hash = "sha256-gkzJytN0TVgz94xIY3K08JsOYG/ny63Oj2eyGWiWH4s=";
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
          # prepend_preloaders = [
          #   {
          #     mime = "{audio,video,image}/*";
          #     run = "mediainfo";
          #   }
          #   {
          #     mime = "application/subrip";
          #     run = "mediainfo";
          #   }
          # ];

          # prepend_previewers = [
          #   {
          #     mime = "{audio,video,image}/*";
          #     run = "mediainfo";
          #   }

          #   {
          #     mime = "application/subrip";
          #     run = "mediainfo";
          #   }

          #   {
          #     name = "*.md";
          #     run = "piper";
          #   }
          # ];
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
        kanagawa-dragon = "${kanagawa-yazi}";
      };
      theme = {
        flavor = {
          dark = "kanagawa-dragon";
          light = "kanagawa-dragon";
        };
        status = {
          separator_open = "";
          separator_close = "";
        };
      };
    };
  };
}
