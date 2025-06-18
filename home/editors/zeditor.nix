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
    # Add an option for rust-analyzer linkedProjects
    rustAnalyzerLinkedProjects = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of linked projects for rust-analyzer.";
      example = ["path/to/project1.toml" "path/to/project2.toml"];
    };
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
        assistants = {
          enable = true;
          version = "2";
          default_open_ai_model = null;
          default_model = {
            provider = "copilot_chat";
            model = "gpt-4";
          };
        };
        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };
        load_direnv = "shell_hook";
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
              linkedProjects = cfg.rustAnalyzerLinkedProjects;
            };
          };
          nixd = {
            binary = {
              path_lookup = true;
            };
            initialization_options = {
              formatting = {
                command = ["alejandra" "--quiet" "--"];
              };
            };
          };
        };
      };
    };
  };
}
