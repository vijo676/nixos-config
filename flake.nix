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
    # Common library and system definitions
    lib = nixpkgs-stable.lib;
    system = "x86_64-linux";
    username = "vijo";
    # Import nixpkgs with configurations
    pkgs = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
    };
    # Import nixpkgs-unstable
    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # NixOS configurations
    nixosConfigurations = {
      work = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/work/configuration.nix
        ];
      };
      xps15 = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/xps15/configuration.nix
        ];
      };
    };
    # Home-manager configurations
    homeConfigurations = {
      work = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/work/home.nix
        ];
      };
      xps15 = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/xps15/home.nix
        ];
      };
    };
  };
}
