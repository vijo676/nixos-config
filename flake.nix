{
    description = "Vijos home manager configuration";
    
    inputs = {
      nixpkgs.url = "nixpkgs/nixos-24.05";

      home-manager = {
        url = "github:nix-community/home-manger/release-24.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    outputs = {nixpkgs, home-manager, ...}:
        let
            lib = nixpkgs.lib;
            systems = "x86_64-linud";
            pkgs = import nixpkgs {inherit system;};
        in {
            homeConfigurations ={
                vijoprofile = home-manager.lib.homeManagerConfiguration{
                    inherit pkgs;
                    modules = [./home.nix]
                };
            };
        };


}
