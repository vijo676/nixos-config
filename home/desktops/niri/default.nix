{
  pkgs,
  lib,
  config,
  ...
}: let
  module_name = "niri";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Niri configuration";
    monitors_config = lib.mkOption {
      default = '''';
      example = ''
        output "eDP-1" {
            mode "1920x1080@60"
            scale 1
            transform "normal"
            position x=0 y=920
          }
      '';
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".source = pkgs.runCommandLocal "niri-config" {} ''
      cp ${./config.kdl} $out
      chmod +w $out

      cat <<'EOF' >> $out
      ${cfg.monitors_config}
      EOF
    '';
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          outerCorners = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "ScreenRecorder";
              }
              {
                id = "Tray";
              }
            ];
            center = [
              {
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                id = "WiFi";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Volume";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Clock";
              }
            ];
          };
        };
        dock.enabled = false;
        colorSchemes.predefinedScheme = "Monochrome";
        #radiusRatio = 0.2;
        dimDesktop = false;
        enableShadows = false;
        location = {
          name = "Copenhagen, Denmark";
        };
        wallpaper = {
          enabled = true;
          directory = builtins.toPath ../../../wallpapers;
        };
        network.wifiEnabled = false;
        notifications.alwaysOnTop = true;
        nightLight.enabled = true;
      };
    };
  };
  imports = [
    ../theme.nix
  ];
}
