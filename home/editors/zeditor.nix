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
      example = [
        "path/to/project1.toml"
        "path/to/project2.toml"
      ];
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
        "material-icon-theme"
        "zig"
        "kdl"
      ];
      userSettings = {
        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };
        features = {
          edit_prediction_provider = "copilot";
        };
        load_direnv = "shell_hook";
        vim_mode = true;
        relative_line_numbers = true;
        cursor_blink = false;
        current_line_highlight = "none";
        format_on_save = "on";
        base_keymap = "VSCode";
        theme = {
          mode = "dark";
          dark = "Kanagawa Wave";
          light = "Kanagawa Wave";
        };
        icon_theme = {
          mode = "dark";
          dark = "Material Icon Theme";
          light = "Material Icon Theme";
        };
        buffer_font_family = "RobotoMono Nerd Font Mono";
        buffer_font_size = 18;
        ui_font_family = "RobotoMono Nerd Font Mono";
        ui_font_size = 18;
        inlay_hints = {
          enabled = true;
          show_parameter_hints = true;
          show_other_hints = true;
        };
        git = {
          inline_blame = {
          };
        };
        tabs = {
          show_diagnostics = "all";
          git_status = true;
          file_icons = true;
        };
        project_panel = {
          dock = "right";
          entry_spacing = "standard";
        };
        agent = {
          dock = "left";
          default_width = 250;
          button = true;
        };
        collaboration_panel = {
          button = false;
        };
        languages = {
          Python = {
            language_servers = ["basedpyright" "ruff"];
            format_on_save = "on";
          };
          Rust = {
            language_servers = ["rust-analyzer"];
            format_on_save = "on";
          };
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
            format_on_save = "on";
          };
        };
        lsp = {
          rust-analyzer = {
            binary = {
              path = lib.getExe pkgs.rust-analyzer;
            };
            initialization_options = {
              linkedProjects = cfg.rustAnalyzerLinkedProjects;
              files.watcher = "server";
              files.exclude = [
                "**/target/**"
                "**/.git/**"
                "**/out/**"
                "**/dist/**"
              ];
              cargo.targetDir = "target/ra";
            };
          };
          nixd = {
            settings = {
              formatting = {
                command = ["alejandra"];
              };
            };
          };
        };
      };
      userKeymaps = [
        {
          context = "Pane";
          bindings = {
            "alt-shift-w" = [
              "pane::CloseAllItems"
              {"close_pinned" = false;}
            ];
            # Split windows
            "alt-s" = "pane::SplitRight";
            "alt-v" = "pane::SplitDown";
          };
        }
        {
          context = "Workspace";
          bindings = {
            # Navigate between panes
            "alt-h" = "workspace::ActivatePaneLeft";
            "alt-j" = "workspace::ActivatePaneDown";
            "alt-k" = "workspace::ActivatePaneUp";
            "alt-l" = "workspace::ActivatePaneRight";

            # Move editor to adjacent groups
            "alt-shift-h" = "workspace::SwapPaneLeft";
            "alt-shift-j" = "workspace::SwapPaneDown";
            "alt-shift-k" = "workspace::SwapPaneUp";
            "alt-shift-l" = "workspace::SwapPaneRight";

            "ctrl-alt-a" = "assistant::ToggleFocus";
          };
        }
        {
          context = "BufferSearchBar && !in_replace > Editor";
          bindings = {
            # Search result navigation
            "ctrl-n" = "search::NextHistoryQuery";
            "ctrl-p" = "search::PreviousHistoryQuery";
          };
        }
      ];
    };
  };
}
