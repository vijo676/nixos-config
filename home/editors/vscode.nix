{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "vscode";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Visual Studio Code";
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
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        jnoortheen.nix-ide
        charliermarsh.ruff
        ms-python.python
        ms-python.vscode-pylance
        rust-lang.rust-analyzer
        vscodevim.vim
        github.copilot
        github.vscode-github-actions
        tamasfe.even-better-toml
        usernamehw.errorlens
        naumovs.color-highlight
        tal7aouy.icons
        jdinhlife.gruvbox
      ];
      profiles.default.userSettings = {
        "rust-analyzer.linkedProjects" = cfg.rustAnalyzerLinkedProjects;
        "editor.fontFamily" = "CaskaydiaCove Nerd Font";
        "editor.minimap.enabled" = false;
        "github.copilot.enable" = {
          "*" = true;
          "markdown" = true;
        };
        "workbench.sideBar.location" = "right";
        "workbench.iconTheme" = "icons";
        "workbench.colorTheme" = "Gruvbox Dark Hard";

        # Enable auto-formatting on save
        "editor.formatOnSave" = true;
        "zig.zls.enabled" = "on";
        "[zig]" = {
          "editor.formatOnSave" = true;
          "editor.stickyScroll.defaultModel" = "foldingProviderModel";
          "files.eol" = "\n";
        };

        # nix settings
        "[nix]" = {
          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = ["nixfmt"];
              };
            };
          };
        };
      };
      profiles.default.keybindings = [
        {
          key = "ctrl+w";
          command = "workbench.action.closeActiveEditor";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+w";
          command = "workbench.action.closeAllEditors";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+e";
          command = "workbench.view.explorer";
        }
        {
          key = "alt+s";
          command = "workbench.action.splitEditor";
          when = "editorTextFocus";
        }
        {
          key = "alt+v";
          command = "workbench.action.splitEditorDown";
          when = "editorTextFocus";
        }
        {
          key = "alt+h";
          command = "workbench.action.focusLeftGroup";
          when = "editorTextFocus";
        }
        {
          key = "alt+j";
          command = "workbench.action.focusBelowGroup";
          when = "editorTextFocus";
        }
        {
          key = "alt+k";
          command = "workbench.action.focusAboveGroup";
          when = "editorTextFocus";
        }
        {
          key = "alt+l";
          command = "workbench.action.focusRightGroup";
          when = "editorTextFocus";
        }
        {
          key = "alt+e";
          command = "workbench.action.showAllEditors";
        }
        {
          key = "ctrl+alt+f";
          command = "workbench.view.search";
        }
        {
          key = "ctrl+n";
          command = "editor.action.nextMatchFindAction";
          when = "editorFocus && findInputFocussed";
        }
        {
          key = "ctrl+p";
          command = "editor.action.previousMatchFindAction";
          when = "editorFocus && findInputFocussed";
        }
        {
          key = "alt+shift+h";
          command = "workbench.action.moveEditorToLeftGroup";
          when = "editorTextFocus";
        }
        {
          key = "alt+shift+j";
          command = "workbench.action.moveEditorToBelowGroup";
          when = "editorTextFocus";
        }
        {
          key = "alt+shift+k";
          command = "workbench.action.moveEditorToAboveGroup";
          when = "editorTextFocus";
        }
        {
          key = "alt+shift+l";
          command = "workbench.action.moveEditorToRightGroup";
          when = "editorTextFocus";
        }
      ];
    };
  };
}
