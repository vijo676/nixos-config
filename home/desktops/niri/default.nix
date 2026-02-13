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
                focusColor = "primary";
                enableScrollWheel = true;
                emptyColor = "secondary";
                colorizeIcons = false;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
              }
            ];
            center = [
              {
                compactMode = false;
                compactShowAlbumArt = true;
                compactShowVisualizer = false;
                hideMode = "hidden";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 155;
                panelShowAlbumArt = true;
                panelShowVisualizer = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = true;
                useFixedWidth = false;
                visualizerType = "linear";
              }
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "MMM dd, hh:mm";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = false;
              }
              {
                displayMode = "onhover";
                id = "NotificationHistory";
              }
            ];
            right = [
              {
                colorizeIcons = false;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                useFixedWidth = false;
              }
              {
                compactMode = false;
                diskPath = "/";
                id = "SystemMonitor";
                showCpuFreq = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskAvailable = false;
                showDiskUsage = true;
                showDiskUsageAsPercent = false;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = true;
                showNetworkStats = false;
                showSwapUsage = false;
                useMonospaceFont = true;
                usePrimaryColor = false;
              }
              {
                displayMode = "onhover";
                id = "Network";
              }
              {
                displayMode = "onhover";
                id = "Bluetooth";
              }
              {
                displayMode = "onhover";
                id = "Volume";
              }
              {
                deviceNativePath = "BAT0";
                displayMode = "icon-always";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = true;
                showPowerProfiles = true;
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        ui = {
          fontDefault = "Caskaydia Cove Nerd Font";
          fontDefaultScale = 1;
          tooltipsEnabled = true;
        };
        colorSchemes = {
          useWallpapersColors = true;
          predefinedScheme = "Monochrome";
          darkMode = true;
          generationMethod = "tonal-spot";
        };
        dock.enabled = false;
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
        nightLight.enabled = false;
      };
    };
  };
  imports = [
    ../theme.nix
  ];
}
