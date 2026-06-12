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
    programs.noctalia = {
      enable = true;
      settings = {
        shell = {
          font_family = "Caskaydia Cove Nerd Font";
          panel.shadow = false;
        };
        theme = {
          mode = "dark";
          source = "wallpaper";
          wallpaper_scheme = "m3-tonal-spot";
        };
        bar.main = {
          shadow = false;
          start = ["workspaces"];
          center = ["media" "clock" "notifications"];
          end = [
            "cpu"
            "temp"
            "ram"
            "disk"
            "network"
            "bluetooth"
            "volume"
            "battery"
            "session"
          ];
          position = "left";
          margin_edge = 0;
          margin_ends = 0;
          widget_spacing = 10;
          scale = 1;
          thickness = 38;
        };
        dock.enabled = false;
        backdrop.enabled = false;
        wallpaper = {
          enabled = true;
          directory = builtins.toPath ../../../wallpapers;
        };
        location.address = "Copenhagen, Denmark";
        notification.layer = "top";
        nightlight.enabled = false;
        widget = {
          clock = {
            format = "{:%b %d, %H:%M}";
            tooltip_format = "{:%H:%M  %a, %b %d}";
          };
          media.max_length = 155;
          active_window.max_length = 145;
          disk = {
            type = "sysmon";
            stat = "disk_pct";
            path = "/";
          };
        };
      };
    };
  };
  imports = [
    ../theme.nix
  ];
}
