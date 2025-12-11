{
  inputs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.dank-greeter;
in {
  imports = [
    inputs.dankMaterialShell.nixosModules.greeter
  ];

  options.modules.dank-greeter = {
    enable = mkEnableOption "DankMaterialShell greeter";
  };

  config = mkIf cfg.enable {
    programs.dankMaterialShell.greeter = {
      enable = true;
      compositor.name = "hyprland";
      configHome = "/home/vijo";
      logs = {
        save = true;
        path = "tmp/dms-greeter.log";
      };
    };
  };
}
