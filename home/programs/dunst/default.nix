{pkgs, ...}: {
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.kanagawa-icon-theme;
      name = "Kanagawa";
    };
    settings = {
      global = {
        frame_color = "#1A1A1A";
        separator_color = "frame";
        highlight = "#957FB8";
        rounded = "yes";
        origin = "top-right";
        alignment = "left";
        vertical_alignment = "center";
        width = "600";
        height = "400";
        scale = 0;
        gap_size = 0;
        progress_bar = true;
        transparency = 5;
        text_icon_padding = 0;
        sort = "yes";
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        corner_radius = 10;
        follow = "mouse";
        font = "Caskaydia Cove Nerd Font 12";
        format = "<b>%s</b>\\n%b";
        frame_width = 1;
        offset = "15x15";
        horizontal_padding = 10;
        icon_position = "left";
        indicate_hidden = "yes";
        min_icon_size = 0;
        max_icon_size = 64;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
        padding = 10;
        plain_text = "no";
        separator_height = 2;
        show_indicators = "yes";
        shrink = "no";
        word_wrap = "yes";
      };

      fullscreen_delay_everything = {
        fullscreen = "delay";
      };

      urgency_critical = {
        background = "#1A1A1A";
        foreground = "#C34043";
        frame_color = "#C34043";
        timeout = "0";
      };
      urgency_low = {
        background = "#1A1A1A";
        foreground = "#DCD7BA";
        timeout = "4";
      };
      urgency_normal = {
        background = "#1A1A1A";
        foreground = "#DCD7BA";
        timeout = "8";
      };
    };
  };
}
