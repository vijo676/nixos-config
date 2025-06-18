{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/desktops/hyprland/scripts/edot.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # User account
  users.users.vijo = {
    isNormalUser = true;
    description = "VitaleJ";
    extraGroups = ["networkmanager" "wheel" "dialout"];
  };

  # Udev rules
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
  '';

  # Networking
  networking.hostName = "vj-work";
  networking.firewall.trustedInterfaces = ["enp195s0f3u2"];
  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;

  # Firewall
  networking.firewall.enable = false;

  environment.variables = {
    # NODE_PATH = "${pkgs.nodejs_18}/bin/node";
  };

  # Enable Hyprland with login manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = "Hyprland -c ${pkgs.nwg-hello}/bin/nwg-hello";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        # command = "${pkgs.hyprland}/bin/Hyprland -c ${pkgs.nwg-hello}/etc/nwg-hello/hyprland.conf";
        user = "greeter";
      };
    };
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.mime.defaultApplications = {
    "default-web-browser" = ["firefox.desktop"];
    "text/html" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
  security.pam.services.hyprlock = {};
  security.pam.services.greetd.gnupg = {
    enable = true;
    noAutostart = true;
  };
  services.blueman.enable = true;

  # Firmware updater
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Bluetooth
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

  # Printer stuff
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.enable = true;

  # Nix settings
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Timezone and language settings
  time.timeZone = "Europe/Copenhagen";
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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us,dk";
    xkb.options = "grp:win_space_toggle";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.jetbrains-mono
  ];

  # System wide packages
  environment.systemPackages = with pkgs; [
    slack
    wget
    _1password-gui-beta
    rustup
    cargo
    gcc
    libgcc
    python3
    python312Packages.pip
    git
    jq
    alejandra
    remmina
    postman
    nixd
    spotify
    usbutils
    pkg-config
    firefox
    nautilus
    hyprpolkitagent
    nixd
    hyprshot
    wl-clipboard
    marktext
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
