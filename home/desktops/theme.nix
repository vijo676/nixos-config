{pkgs, ...}: {
  # Themes
  services.xsettingsd.enable = true;
  gtk = {
    enable = true;
    font.name = "Caskaydia Cove Nerd Font";
    font.size = 11;
    gtk2.extraConfig = "
      gtk-application-prefer-dark-theme=1
    ";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
  };
  gtk.gtk4.theme = null;
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 25;
  };
}
