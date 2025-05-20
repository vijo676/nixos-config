{pkgs, ...}: {
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.kanagawa-icon-theme;
      name = "Kanagawa";
    };
    settings = {
      global = {
        frame_color = "#7E9CD8"; # Kanagawa Wave Blue
        separator_color = "frame";
        highlight = "#957FB8"; # Kanagawa Sakura Pink
        rounded = "yes";
        origin = "top-right";
        alignment = "left";
        vertical_alignment = "center";
        width = "400";
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
        font = "jetbrainsmono nerd font 10";
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
        browser = "${browser} --new-tab";
      };

      fullscreen_delay_everything = {fullscreen = "delay";};

      urgency_critical = {
        background = "#2A2A37"; # Kanagawa Storm Gray
        foreground = "#E46876"; # Kanagawa Autumn Red
        frame_color = "#E46876"; # Kanagawa Autumn Red
        timeout = "0";
      };
      urgency_low = {
        background = "#1F1F28"; # Kanagawa Background
        foreground = "#DCD7BA"; # Kanagawa Ivory
        timeout = "4";
      };
      urgency_normal = {
        background = "#1F1F28"; # Kanagawa Background
        foreground = "#DCD7BA"; # Kanagawa Ivory
        timeout = "8";
      };
    };
  };
}
