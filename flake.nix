{
  description = "vijo NixOS configuration";

  inputs = {
    # Pin primary nixpkgs repository
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    # Enable option to use the unstable nixpkgs repo
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    # common library and system definitions
    lib = nixpkgs-stable.lib;
    system = "x86_64-linux";
    username = "vijo";
    # nixpkgs
    pkgs = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
    };
    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    # make hosts configurations
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
            modules = [
              host.config
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = import host.home;
              }
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
            extraSpecialArgs = {inherit inputs pkgsUnstable;};
            modules = [host.home];
          }
      )
      hosts;
  };
}
