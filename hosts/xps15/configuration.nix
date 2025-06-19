{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ../../modules/base {
      inherit pkgs lib;
      username = "vijo";
    })
    ../../modules/steam
    ../../modules/greetd
    ../../modules/hyprland
  ];

  # Nvidia stuff
  services.xserver = {
    videoDrivers = lib.mkDefault ["nvidia"];
  };
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

  networking.hostName = "vj-xps";

  system.stateVersion = "24.11";
}
