{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/base
    ../../modules/niri
    inputs.neovim.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Neovim
  programs.neovim-monica = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    colorschemePackage = pkgs.vimPlugins.kanagawa-paper-nvim;
    colorschemeName = "kanagawa-paper-ink";
  };

  # FUSE (needed by fuse-overlayfs)
  programs.fuse.enable = true;

  # Udev rules
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04f9", ATTRS{idProduct}=="209b", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7c18", MODE="0666"

    SUBSYSTEM=="net", ACTION=="add|change", ENV{ID_VENDOR_ID}=="1d6b", ENV{ID_MODEL_ID}=="0104", ENV{ID_USB_DRIVER}=="rndis_host", ENV{NM_UNMANAGED}="1"
  '';
  networking.firewall.interfaces."usb+".allowedUDPPorts = [67];
  networking.networkmanager.ensureProfiles.profiles.usb-dhcp = {
    connection = {
      id = "usb-dhcp";
      type = "ethernet";
      autoconnect = true;
      multi-connect = "3";
    };
    match = {
      driver = "cdc_ether";
      interface-name = "usb*";
    };
    ipv4 = {
      method = "shared";
    };
    ipv6 = {
      method = "ignore";
    };
  };

  # Tailscale for remote access
  services.tailscale.enable = true;

  # Networking
  networking.hostName = "vj-t14";

  # System wide packages
  environment.systemPackages = with pkgs; [
    _1password-gui-beta
    pkg-config
  ];

  # Hexnode
  systemd.services.hexnode-vm = let
    nixos-system = configuration: (inputs.nixpkgs.lib.nixosSystem {
      modules = [
        configuration
        {nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;}
      ];
    });
    vms = {
      hexnode = {pkgs, ...}: {
        imports = ["${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"];
        virtualisation.graphics = false;

        system.stateVersion = "24.11";

        services.openssh.enable = true;
        services.openssh.settings.PermitRootLogin = "yes";
        users.users.root.openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile inputs.vijo-keys);

        systemd.services.mdm-ubuntu-container = let
          hexnodeEnrollService = pkgs.writeText "hexnode-enroll.service" ''
            [Unit]
            Description=Hexnode MDM First-Boot Enrollment
            After=network-online.target
            Wants=network-online.target

            [Service]
            Type=oneshot
            # Download, execute, and then immediately disable this service
            ExecStart=/bin/bash -c "curl -L https://veo.hexnodemdm.com/enroll/ --output /root/config && chmod +x /root/config && /root/config && systemctl disable hexnode-enroll.service"

            [Install]
            WantedBy=multi-user.target
          '';
        in {
          description = "Ubuntu 24.04 Container for Hexnode MDM";
          wantedBy = ["multi-user.target"];
          after = ["network-online.target"];
          wants = ["network-online.target"];

          path = with pkgs; [debootstrap systemd bash coreutils];

          preStart = ''
            mkdir -p /var/lib/machines/mdm-ubuntu

            if [ ! -f /var/lib/machines/mdm-ubuntu/.setup-complete ]; then
              rm -rf /var/lib/machines/mdm-ubuntu/
              echo "Bootstrapping Ubuntu 24.04 (Noble)... This may take a few minutes."
              debootstrap noble /var/lib/machines/mdm-ubuntu http://archive.ubuntu.com/ubuntu/

              systemd-nspawn --resolv-conf=bind-host -D /var/lib/machines/mdm-ubuntu \
                /bin/bash -c "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && apt-get update && \
                              apt-get install -y curl ca-certificates python3-certifi dmidecode iproute2 net-tools lshw pciutils usbutils dbus tzdata && \
                              update-ca-certificates"
              cp ${hexnodeEnrollService} /var/lib/machines/mdm-ubuntu/etc/systemd/system/hexnode-enroll.service

              mkdir -p /var/lib/machines/mdm-ubuntu/etc/systemd/system/multi-user.target.wants
              ln -s /etc/systemd/system/hexnode-enroll.service /var/lib/machines/mdm-ubuntu/etc/systemd/system/multi-user.target.wants/hexnode-enroll.service
              touch /var/lib/machines/mdm-ubuntu/.setup-complete
            fi
          '';
          serviceConfig = {
            Type = "simple";
            Delegate = true;
            LimitNOFILE = 16384;
            MemoryMax = "512M";
            TasksMax = 128;
            DevicePolicy = "closed";

            TimeoutStartSec = "infinity";
            ExecStart = ''
              ${pkgs.systemd}/bin/systemd-nspawn \
                --keep-unit \
                --boot \
                --machine=mdm-ubuntu \
                --directory=/var/lib/machines/mdm-ubuntu \
                --resolv-conf=bind-host \
                --settings=no \
                --link-journal=no \
                --drop-capability=CAP_SYS_PTRACE \
                --drop-capability=CAP_NET_RAW \
                --drop-capability=CAP_MKNOD \
                --drop-capability=CAP_LINUX_IMMUTABLE \
                --drop-capability=CAP_AUDIT_CONTROL \
                --drop-capability=CAP_AUDIT_WRITE \
                --drop-capability=CAP_SYS_BOOT \
                --bind-ro=/sys/class/dmi/id:/sys/class/dmi/id \
                --bind-ro=/sys/devices/virtual/dmi/id:/sys/devices/virtual/dmi/id
            '';

            ExecStop = "${pkgs.systemd}/bin/machinectl poweroff mdm-ubuntu";
            Restart = "always";
            RestartSec = "10s";
          };
        };
      };
    };
    hexnodeVM = nixos-system vms.hexnode;
  in {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    path = [hexnodeVM.config.system.build.vm];
    environment = {
      QEMU_NET_OPTS = "hostfwd=tcp::8022-:22";
      NIX_DISK_IMAGE = "/var/lib/vms/hexnode.qcow2";
    };
    script = ''
      d=/sys/class/dmi/id
      r() { [ -r "$d/$1" ] && tr -d ',\n' < "$d/$1" | tr -c 'A-Za-z0-9._:/-' '_'; }
      export QEMU_OPTS="$QEMU_OPTS \
        -smbios type=0,vendor=$(r bios_vendor),version=$(r bios_version),date=$(r bios_date),release=$(r bios_release) \
        -smbios type=1,manufacturer=$(r sys_vendor),product=$(r product_name),version=$(r product_version),serial=$(r product_serial),uuid=$(r product_uuid),sku=$(r product_sku),family=$(r product_family) \
        -smbios type=2,manufacturer=$(r board_vendor),product=$(r board_name),version=$(r board_version),serial=$(r board_serial),asset=$(r board_asset_tag) \
        -smbios type=3,manufacturer=$(r chassis_vendor),version=$(r chassis_version),serial=$(r chassis_serial),asset=$(r chassis_asset_tag)"

      exec run-${hexnodeVM.config.networking.hostName}-vm
    '';
  };

  system.stateVersion = "24.11";
}
