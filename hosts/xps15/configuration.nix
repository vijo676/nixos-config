{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/base
  ];

  # Enable networking
  networking.hostName = "vj-xps";

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

  services.xserver = {
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

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  system.stateVersion = "24.11";
}
