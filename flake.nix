{
  description = "Multi-host NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Import custom library functions
      lib = nixpkgs.lib.extend (
        final: prev: {
          myLib = import ./lib { lib = final; };
        }
      );

      # Common module lists
      commonModules = [
        agenix.nixosModules.default
        ./modules/core
        ./hosts/default.nix
      ];

      # Function to create a NixOS system configuration
      mkSystem =
        hostname: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs lib; };
          modules =
            commonModules
            ++ extraModules
            ++ [
              ./hosts/${hostname}
            ];
        };

      # Function to create home-manager configuration
      mkHome =
        username: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/profiles/${username}.nix
          ]
          ++ extraModules;
        };

    in
    {
      # NixOS Configurations
      nixosConfigurations = {
        andromeda = mkSystem "andromeda" [ ];

        centauri = mkSystem "centauri" [
          # ./modules/services
          # ./modules/hardware/nfs.nix
        ];

        jupiter = mkSystem "jupiter" [
          ./modules/desktop
          ./modules/hardware/amd.nix
          ./modules/hardware/audio.nix
          ./modules/hardware/bluetooth.nix
          ./modules/services/productivity/actual.nix
          ./modules/services/media/navidrome.nix
        ];
      };

      # Home Manager Configurations
      homeConfigurations = {
        frank = mkHome "frank" [
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri
          inputs.niri.homeModules.niri
        ];
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
