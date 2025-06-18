{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.hostName = "vj-xps";
  networking.networkmanager.enable = true;

  # Set your time zone.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us,dk";
    xkb.options = "grp:alt_caps_toggle";
    videoDrivers = lib.mkDefault ["nvidia"];
  };

  # Nvidia GPU
  hardware.nvidia = {
    prime = {
      # Sync Mode
      sync.enable = true;
      intelBusId = lib.mkDefault "PCI:0:2:0";
      nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    };
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # D-Bus service to check the availability of dual-GPU
  services.switcherooControl.enable = lib.mkDefault true;
  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
    extraPackages = with pkgs; [intel-media-driver intel-compute-runtime nvidia-vaapi-driver];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
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

  users.users.vijo = {
    isNormalUser = true;
    description = "vjxps";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # fonts
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
    rustup
    cargo
    gcc
    libgcc
    python3
    python312Packages.pip
    jq
    alejandra
    spotify
    usbutils
    firefox
    discord
    # needed for hyprland
    nautilus
    hyprpolkitagent
    nwg-hello
    nixd
    hyprshot
    wl-clipboard
  ];

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  xdg.mime.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.stateVersion = "24.11";
}
