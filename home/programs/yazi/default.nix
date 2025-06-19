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
      settings = {
        mgr = {
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
        keymap = {
          manager.prepend_keymap = [
            {
              on = ["e"];
              run = "open";
            }
            {
              on = ["d"];
              run = "remove --force";
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
