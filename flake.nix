{
  description = "Vijo nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    nixpkgs,
    catppuccin,
    home-manager,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      work = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/work/configuration.nix
        ];
      };
    };
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
