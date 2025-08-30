{
  pkgs,
  lib,
  username,
  ...
}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  programs.zsh.enable = true;

  # Remember to set password with passwd
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # Garbage collection weekly
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 30d";
  };

  time.timeZone = "Europe/Copenhagen";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };
  services.xserver = {
    enable = true;
    xkb.layout = "us,dk";
    xkb.options = "grp:alt_caps_toggle";
  };
  security = {
    rtkit.enable = true;
  };

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Printer stuff
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      # noto-fonts

      # nerd font
      nerd-fonts.caskaydia-cove
      nerd-fonts.jetbrains-mono
    ];
    # disable this to use specified fonts by user instead of default ones
    # enableDefaultPackages = false;

    # user fonts
    # fontconfig.defaultFonts = {
    #   serif = ["Noto Serif"];
    #   sansSerif = ["Noto Sans"];
    #   monospace = ["CaskaydiaCove Nerd Font"];
    #   emoji = ["Noto Color Emoji"];
    # };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; # Disable root login
      X11Forwarding = true;
    };
    openFirewall = true;
  };

  # Enable sound with pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '')
    ];
  };

  # Bootloader
  boot = {
    tmp.cleanOnBoot = true; # Clean /tmp on boot
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # FW updater
  hardware.enableAllFirmware = true;
  services.fwupd.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # System wide packages
  environment.systemPackages = with pkgs; [
    iperf # measure network performance
    slack
    curl
    wget
    rustup
    cargo
    gcc
    zig
    zls
    git
    libgcc
    python3
    python312Packages.pip
    jq
    alejandra
    nil
    spotify
    usbutils
    firefox
    discord
    fastfetch
    imv
    mpv
    # needed for hyprland
    nautilus
    hyprpolkitagent
    nwg-hello
    nixd
    hyprshot
    wl-clipboard
    kitty
    cyme # Modern "lsusb"
    caligula # TUI burning tool
    nh # nix helper tool
    picocom # terminal emulator for serial
    protonvpn-gui # ProtonVPN GUI
    ripgrep # modern grep
    fd # modern find
    tailspin # modern tail
  ];

  xdg.mime.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
