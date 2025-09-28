{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  in {
    nixosConfigurations = {
      hetzner = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/hetzner/configuration.nix
            agenix.nixosModules.default
        ];
      };
      homelab = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/homelab/configuration.nix
            agenix.nixosModules.default
        ];
      };
      jupiter = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        inherit system;
        modules = [
          ./hosts/jupiter/configuration.nix
            agenix.nixosModules.default
            # home-manager.nixosModules.home-manager {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.frank = ./home.nix;
            # }
        ];
      };
    };
    homeConfigurations = {
      "frank" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  };
}
