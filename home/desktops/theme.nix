{pkgs, ...}: {
  # Themes
  services.xsettingsd.enable = true;
  gtk = {
    enable = true;
    font.name = "Caskaydia Cove Nerd Font";
    font.size = 11;
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "Everforest-Dark-BL";
    };
    iconTheme = {
      package = pkgs.everforest-gtk-theme;
      name = "Everforest-Dark";
    };
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
  qt.style.name = "Everforest-Dark-BL";
  home.sessionVariables.GTK_THEME = "Everforest-Dark-BL";
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 25;
  };
}
