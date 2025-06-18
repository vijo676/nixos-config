{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        unlock_cmd = "pkill --signal SIGUSR1 hyprlock";
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300; # 5 mins
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 360; # 6 mins
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
