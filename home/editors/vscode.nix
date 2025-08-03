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
      example = ["path/to/project1.toml" "path/to/project2.toml"];
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        kamadorueda.alejandra
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
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.colorTheme" = "Kanagawa Dragon";

        # Testing settings for Python
        "python.testing.pytestEnabled" = true;
        "python.testing.unittestEnabled" = false;
        "python.testing.cwd" = "\${workspaceFolder}/autotest/tests";
        "python.envFolders" = "\${workspaceFolder}/autotest/.autotest-venv";

        # Enable auto-formatting on save
        "editor.formatOnSave" = true;
        "zig.zls.enabled" = "on";
        "[zig]" = {
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "ziglang.vscode-zig";
          "editor.stickyScroll.defaultModel" = "foldingProviderModel";
          "files.eol" = "\n";
        };
      };
    };
  };
}
