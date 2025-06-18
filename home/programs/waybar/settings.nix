{pkgs, ...}: {
  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "top";
    height = 34;
    exclusive = true;
    passthrough = false;
    gtk-layer-shell = true;
    # ipc = true;
    fixed-center = true;
    margin-top = 10;
    margin-left = 10;
    margin-right = 10;
    margin-bottom = 0;

    modules-left = [
      "hyprland/workspaces"
    ];
    modules-center = [
      "clock"
    ];
    modules-right = [
      "hyprland/language"
      "custom/gpuinfo"
      "cpu"
      "memory"
      "backlight"
      "pulseaudio"
      "pulseaudio#microphone"
      "bluetooth"
      "network"
      "battery"
      "custom/power"
    ];
    "hyprland/workspaces" = {
      disable-scroll = true;
      all-outputs = true;
      active-only = false;
      on-click = "activate";
      persistent-workspaces = {
        "*" = [1 2 3 4 5 6 7 8 9];
      };
    };
    "clock" = {
      format = "{:%a %d %b %R}";
      format-alt = "{:󰃭 %d·%m·%y %R}";
      # format-alt = "{:%I:%M %p}";
      tooltip-format = "<tt>{calendar}</tt>";
      calendar = {
        mode = "month";
        mode-mon-col = 3;
        on-scroll = 1;
        on-click-right = "mode";
        format = {
          months = "<span color='#ffead3'><b>{}</b></span>";
          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          today = "<span color='#ff6699'><b>{}</b></span>";
        };
      };
    };
    "cpu" = {
      interval = 10;
      format = "󰍛 {usage}%";
      format-alt = "{icon0}{icon1}{icon2}{icon3}";
      format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
    };
    "memory" = {
      interval = 30;
      format = "󰾆 {percentage}%";
      format-alt = "󰾅 {used}GB";
      max-length = 10;
      tooltip = true;
      tooltip-format = " {used:.1f}GB/{total:.1f}GB";
    };

    "backlight" = {
      format = "{icon} {percent}%";
      format-icons = ["" "" "" "" "" "" "" "" ""];
      on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
      on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
    };

    "network" = {
      # on-click = "nm-connection-editor";
      # "interface" = "wlp2*"; # (Optional) To force the use of this interface
      format-wifi = "󰤨 Wi-Fi";
      # format-wifi = " {bandwidthDownBits}  {bandwidthUpBits}";
      # format-wifi = "󰤨 {essid}";
      format-ethernet = "󱘖 Wired";
      # format-ethernet = " {bandwidthDownBits}  {bandwidthUpBits}";
      format-linked = "󱘖 {ifname} (No IP)";
      format-disconnected = "󰤮 Off";
      # format-disconnected = "󰤮 Disconnected";
      format-alt = "󰤨 {signalStrength}%";
      tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
    };

    "bluetooth" = {
      format = "";
      # format-disabled = ""; # an empty format will hide the module
      format-connected = " {num_connections}";
      tooltip-format = " {device_alias}";
      tooltip-format-connected = "{device_enumerate}";
      tooltip-format-enumerate-connected = " {device_alias}";
      on-click = "blueman-manager";
    };

    "pulseaudio" = {
      format = "{icon} {volume}";
      format-muted = " ";
      on-click = "pavucontrol -t 3";
      tooltip-format = "{icon} {desc} // {volume}%";
      scroll-step = 4;
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = ["" "" ""];
      };
    };

    "pulseaudio#microphone" = {
      format = "{format_source}";
      format-source = " {volume}%";
      format-source-muted = "";
      on-click = "pavucontrol -t 4";
      tooltip-format = "{format_source} {source_desc} // {source_volume}%";
      scroll-step = 5;
    };

    "tray" = {
      icon-size = 36;
      spacing = 20;
    };

    "battery" = {
      states = {
        good = 95;
        warning = 30;
        critical = 20;
      };
      format = "{icon} {capacity}%";
      # format-charging = " {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-alt = "{time} {icon}";
      format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
    };

    "hyprland/language" = {
      format = " {short}"; # can use {short} and {variant}
      on-click = "${../../desktops/hyprland/scripts/keyboardswitch.sh}";
    };

    "custom/power" = {
      format = "  {}";
      on-click = "wlogout -b 3";
      interval = 86400; # once every day
      tooltip = true;
    };
  };
}
