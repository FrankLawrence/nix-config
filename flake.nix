{
  description = "Multi-host NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  let
    system = "x86_64-linux";
    
    # Import custom library functions
    lib = nixpkgs.lib.extend (final: prev: {
      myLib = import ./lib { lib = final; };
    });
    
    # Common module lists
    commonModules = [
      agenix.nixosModules.default
      ./modules/core
      ./hosts/default.nix
    ];
    
    # Function to create a NixOS system configuration
    mkSystem = hostname: extraModules: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs lib; };
      modules = commonModules ++ extraModules ++ [
        ./hosts/${hostname}
      ];
    };
    
    # Function to create home-manager configuration
    mkHome = username: extraModules: home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home/profiles/${username}.nix
      ] ++ extraModules;
    };
    
  in {
    # NixOS Configurations
    nixosConfigurations = {
      andromeda = mkSystem "andromeda" [ ];
      
      centauri = mkSystem "centauri" [
        ./modules/services
        ./modules/hardware/nfs.nix
      ];
      
      jupiter = mkSystem "jupiter" [
        ./modules/desktop
        ./modules/hardware/amd.nix
        ./modules/hardware/audio.nix
        ./modules/hardware/bluetooth.nix
        ./modules/services/productivity/actual.nix
      ];
    };

    # Home Manager Configurations
    homeConfigurations = {
      frank = mkHome "frank" [ ];
    };
    
    # Development shell
    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      buildInputs = with nixpkgs.legacyPackages.${system}; [
        git
        agenix.packages.${system}.default
        nixpkgs-fmt
        nil
      ];
    };
  };
}
