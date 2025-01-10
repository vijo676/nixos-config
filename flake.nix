# Vijo NixOS Configuration
{
  description = "Vijo NixOS configuration";

  # Inputs
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  # Outputs
  outputs = {
    nixpkgs,
    home-manager,
    catppuccin,
    ghostty,
    ...
  }: let
    # Common library and system definitions
    lib = nixpkgs.lib;
    system = "x86_64-linux";

    # Import nixpkgs with configurations
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # NixOS configurations
    nixosConfigurations = {
      # Work system configuration
      work = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/work/configuration.nix
          {
            environment.systemPackages = [ghostty.packages.${system}.default];
          }
        ];
      };
    };

    # Home-manager configurations
    homeConfigurations = {
      work = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/work/home.nix
          catppuccin.homeManagerModules.catppuccin
        ];
      };
    };
  };
}
