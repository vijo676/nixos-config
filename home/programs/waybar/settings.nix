{ pkgs, ... }:
{
  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "top";
    height = 30;
    ipc = true;
    margin-top = 0;
    margin-left = 0;
    margin-right = 0;
    margin-bottom = -8;

    modules-left = [
      "hyprland/workspaces"
      "hyprland/window"
    ];
    modules-center = [
      "group/time"
    ];
    modules-right = [
      "privacy"
      "hyprland/language"
      "group/hardware"
      "group/sound"
      "group/network"
      "battery"
      "custom/power"
    ];
    "hyprland/window" = {
      format = "{initialTitle}";
      max-length = 35;
      rewrite = {
        "" = "Hyprland";
      };
      seperate-outputs = false;
    };
    "hyprland/workspaces" = {
      disable-scroll = true;
      all-outputs = true;
      active-only = false;
      on-click = "activate";
      persistent-workspaces = {
        "*" = [
          1
          2
          3
          4
          5
          6
        ];
      };
    };
    "group/time" = {
      orientation = "horizontal";
      modules = [
        "clock"
        "clock#simple"
      ];
    };
    "clock" = {
      format = "{:L%a %d, %b %Y}";
      format-alt = "{:%d-%m-%Y}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };
    "clock#simple" = {
      format = "{:%H:%M:%S}";
      tooltip = false;
      interval = 1;
    };
    "privacy" = {
      icon-size = 15;
      spacing = 8;
    };
    "hyprland/language" = {
      format = "<span color=\"#DCA561\"></span>  {}";
      format-en = "EN";
      format-dk = "DK";
    };
    "group/hardware" = {
      orientation = "horizontal";
      modules = [
        "cpu"
        "memory"
        "backlight"
      ];
    };
    "cpu" = {
      format = "<span color=\"#DCA561\"></span>  {usage}%";
      tooltip = false;
    };
    "memory" = {
      interval = 30;
      format = "<span color=\"#DCA561\"></span>  {percentage}%";
      tooltip = true;
      tooltip-format = " {used:.1f}GB/{total:.1f}GB";
    };
    "backlight" = {
      format = "<span color=\"#DCA561\"></span>  {percent}%";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
      on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
      on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
    };
    "group/sound" = {
      orientation = "horizontal";
      modules = [
        "pulseaudio"
        "pulseaudio#microphone"
      ];
    };
    "pulseaudio" = {
      format = "<span color=\"#DCA561\">{icon}</span>  {volume}%";
      tooltip-format = "{icon} {desc} // {volume}%";
      scroll-step = 4;
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      format-muted = " ";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        default = [
          ""
          ""
          ""
        ];
      };
    };
    "pulseaudio#microphone" = {
      format = "{format_source}";
      format-source = "<span color=\"#DCA561\"></span> {volume}%";
      format-source-muted = "";
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
      on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
      tooltip-format = "Fifine K680";
      scroll-step = 5;
    };
    "group/network" = {
      orientation = "horizontal";
      modules = [
        "network"
        "bluetooth"
      ];
    };
    "bluetooth" = {
      on-click = "blueman-manager";
      format = "<span color=\"#DCA561\"></span>";
      format-connected = "<span color=\"#DCA561\"> {num_connections}</span>";
      format-disabled = "<span color=\"#DCA561\"></span>";
      tooltip-format = " {device_alias}";
      tooltip-format-connected = "{device_enumerate}";
      tooltip-format-enumerate-connected = " {device_alias}";
    };
    "network" = {
      # "interface" = "wlp2*"; # (Optional) To force the use of this interface
      on-click = "nm-connection-editor";
      format-wifi = "<span color=\"#DCA561\"> </span>";
      format-ethernet = "<span color=\"#DCA561\"> </span>";
      format-linked = "󱘖 {ifname} (No IP)";
      format-disconnected = "<span color=\"#DCA561\">⚠</span>";
      tooltip = false;
    };
    "battery" = {
      orientation = "horizontal";
      modules = [ "battery" ];
      states = {
        good = 95;
        warning = 30;
        critical = 20;
      };
      format = "<span color=\"#DCA561\">{icon}</span>  {capacity}%";
      format-charging = "<span color=\"#DCA561\"></span>  {capacity}%";
      format-plugged = "<span color=\"#DCA561\"></span>  {capacity}%";
      format-alt = "{time} {icon}";
      format-icons = [
        "󰂎"
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
    };
    "custom/power" = {
      format = "<span color=\"#DCA561\">   </span>";
      on-click = "wlogout -b 3";
      interval = 86400; # once every day
      tooltip = true;
    };
  };
}
