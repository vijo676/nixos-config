{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "zeditor";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Zed";
  };
  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "kanagawa-themes"
        "ruff"
      ];
      userSettings = {
        features = {
          copilot = true;
        };
        vim_mode = true;
        base_keymap = "VSCode";
        theme = {
          mode = "dark";
          dark = "Kanagawa Dragon";
          light = "Kanagawa Dragon";
        };
        shell = "system";
        line_height = "comfortable";
        font_family = "CaskaydiaCove Nerd Font";
        font_size = 15;
        ui_font_size = 15;
        buffer_font_size = 15;
        hour_format = "hour24";
        env = {
          TERM = "xterm-ghostty";
        };
        languages = {
          Python = {
            language_servers = ["ruff"];
            format_on_save = "on";
          };
        };
        lsp = {
          rust-analyzer = {
            binary = {
              path_lookup = true;
            };
            initialization_options = {
              linkedProjects = [
              ];
            };
          };
          nix = {
            binary = {
              path_lookup = true;
            };
          };
        };
      };
    };
  };
}
