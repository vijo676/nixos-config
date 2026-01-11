{
  pkgs,
  lib,
  config,
  extraConfig,
  inputs,
  ...
}: let
  module_name = "niri";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Niri configuration";
  };
  config = mkIf cfg.enable {
    # Niri-specific configuration goes here
    # Theme and dankMaterialShell are now in ../theme.nix
  xdg.configFile."niri/config.kdl".source = pkgs.runCommandLocal "niri-config" {} ''
    cp ${./config.kdl} $out
    chmod +w $out

  '';
  };
  imports = [
    ../theme.nix
  ];
}
