{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    # Theme
    gtk = {
      enable = true;
      theme = {
        package = pkgs.kanagawa-gtk-theme;
        name = "Kanagawa";
      };
      iconTheme = {
        package = pkgs.kanagawa-icon-theme;
        name = "Kanagawa";
      };
    };
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.volantes-cursors;
      name = "volantes-cursors";
      size = 24;
    };
  };
}
