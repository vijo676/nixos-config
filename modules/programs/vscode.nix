{
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
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = [
        "kamadorueda.alejandra"
        "bbenoist.nix"
        "jnoortheen.nix-ide"
        "charliermarsh.ruff"
        "ms-python.python"
        "ms-python.vscode-pylance"
        "rust-lang.rust-analyzer"
        "vscodevim.vim"
        "github.copilot"
        "github.vscode-github-actions"
        "tamasfe.even-better-toml"
        "usernamehw.errorlens"
        "naumovs.color-highlight"
        "tal7aouy.icons"
        "jdinhlife.gruvbox"
      ];
      userSettings = {
        "rust-analyzer.linkedProjects" = [];
        "workbench.colorTheme" = "Kanagawa Dragon";
        "editor.fontFamily" = "CaskaydiaCove Nerd Font";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.minimap.enabled" = false;
      };
    };
  };
}
