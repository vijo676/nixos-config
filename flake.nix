{
  description = "vijo NixOS configuration";

  inputs = {
    # Pin primary nixpkgs repository
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    # Enable option to use the unstable nixpkgs repo
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    hyprland.url = {
     url = "github:hyprwm/Hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ghostty,
    split-monitor-workspaces,
    ...
  }: let
    # Common library and system definitions
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    username = "vijo";

    # Import nixpkgs with configurations
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
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
      # laptop system configuration
      xps15 = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/xps15/configuration.nix
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
        ];
      };
      xps15 = home-manager.lib.homeManagerConfiguration {
        inherit pkgs split-monitor-workspaces;
        modules = [
          ./hosts/xps15/home.nix
        ];
      };
    };
  };
}
