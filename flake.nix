{
  description = "vijo NixOS configuration";

  inputs = {
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:Maroka-chan/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    lanzaboote,
    noctalia,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    username = "vijo";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
    };
    mkHost = name: {
      config = ./hosts/${name}/configuration.nix;
      home = ./hosts/${name}/home.nix;
    };
    hosts = {
      desktop = mkHost "desktop";
      work = mkHost "work";
      xps15 = mkHost "xps15";
    };
  in {
    # Dev shells
    devShells = {
      x86_64-linux.default = pkgs.mkShell {
        name = "default";
        buildInputs = [
          # nothing special for now
        ];
        shellHook = ''
          echo "💻 Default shell loaded!"
        '';
      };
    };
    # NixOS configurations
    nixosConfigurations =
      lib.mapAttrs (
        name: host:
          lib.nixosSystem {
            inherit system pkgs;
            specialArgs = {
              inherit inputs system username;
            };
            modules =
              [
                noctalia.nixosModules.default
                host.config
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.${username} = {
                    imports = [
                      host.home
                      noctalia.homeModules.default
                    ];
                  };
                  home-manager.extraSpecialArgs = {
                    inherit inputs;
                  };
                }
              ]
              ++ lib.optionals (name == "desktop") [
                lanzaboote.nixosModules.lanzaboote
                (
                  {lib, ...}: {
                    # Lanzaboote replaces systemd-boot
                    boot.loader.systemd-boot.enable = lib.mkForce false;
                    boot.lanzaboote = {
                      enable = true;
                      pkiBundle = "/var/lib/sbctl";
                    };
                  }
                )
              ];
          }
      )
      hosts;
    # Home-manager configurations
    homeConfigurations =
      lib.mapAttrs (
        name: host:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
            };
            modules = [
              host.home
              noctalia.homeModules.default
            ];
          }
      )
      hosts;
    formatter.${system} = pkgs.alejandra;
  };
}
