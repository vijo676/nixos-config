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
      extensions = with pkgs.vscode-extensions; [
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
      userSettings = {
        "rust-analyzer.linkedProjects" = cfg.rustAnalyzerLinkedProjects;
        "workbench.colorTheme" = "Kanagawa Dragon";
        "editor.fontFamily" = "CaskaydiaCove Nerd Font";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.minimap.enabled" = false;
      };
    };
  };
}
