{cfg, ...}: {
  # Wallpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload = [cfg.wallpaper_path];
      wallpaper = ", ${cfg.wallpaper_path}";
    };
  };
}
