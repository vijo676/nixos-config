{
  pkgs,
  cfg,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 0;
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = false;
      };
      background = [
        {
          monitor = "";
          path = "${cfg.wallpaper_path}";
          blur_passes = 2;
          blur_size = 2;
        }
      ];
      input-field = {
        monitor = "";
        size = "300, 40";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(76, 86, 106, 0.1)";
        font_color = "rgb(191, 186, 159)";
        fade_on_empty = false;
        font_family = "CaskaydiaCove Nerd Font";
        fail_color = "rgb(237, 135, 150)";
        placeholder_text = "Password...";
        hide_input = false;
        position = "0, -200";
        halign = "center";
        valign = "center";
      };
      label = {
        monitor = "";
        text = "$TIME";
        color = "rgb(191, 186, 159)";
        font_family = "Caskaydia Cove Nerd Font Bold";
        font_size = 64;
        position = "0, 300";
        halign = "center";
        valign = "center";
      };
    };
  };
}
