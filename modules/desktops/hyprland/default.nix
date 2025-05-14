{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "hyprland";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Hyprland configuration";
  };
  config =
    mkIf cfg.enable {
      lib.imports = [
        ./binds.nix
        ./settings.nix
      ];
      # Kitty is required for the default Hyprland config
      programs.kitty = {
        enable = true;
      };
      home.packages = with pkgs; [
        swaybg
      ];
      wayland.windowManager.hyprland = {
        enable = true;
      };
      wayland.windowManager.hyprland.extraConfig = "
      monitor=,preferred,auto,auto
  ";

      home.sessionVariables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      };
    };
}
