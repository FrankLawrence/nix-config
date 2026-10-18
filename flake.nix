{
  description = "Multi-host NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
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

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    areofyl-fetch = {
      url = "github:areofyl/fetch";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    waterfox = {
      url = "github:realitymolder/waterfox-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      agenix,
      home-manager,
      disko,
      niri,
      dgop,
      nix-darwin,
      waterfox,
      helium,
      ...
    }@inputs:
    let
      # Systems the dev shell / packages should exist for
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

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
          system = "x86_64-linux";
          specialArgs = { inherit inputs lib; };
          modules = commonModules ++ extraModules ++ [ ./hosts/${hostname} ];
        };

      mkHome =
        username: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
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
        andromeda = mkSystem "andromeda" [
          disko.nixosModules.disko
        ];

        centauri = mkSystem "centauri" [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.frank = import ./home/profiles/frank-server.nix;
          }
          ./modules/services
          ./modules/hardware/nfs.nix
        ];

        jupiter = mkSystem "jupiter" [
          ./modules/desktop
          ./modules/hardware/amd.nix
          ./modules/hardware/audio.nix
          ./modules/hardware/bluetooth.nix
        ];

      };

      darwinConfigurations.Astra = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          agenix.darwinModules.default
          home-manager.darwinModules.home-manager
          ./hosts/astra
          {
            nixpkgs.overlays = [
              (final: prev: {
                omniwm = inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.omniwm;
                whatcable = inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.whatcable;
              })
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.frank = import ./home/profiles/astra.nix;
          }
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

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.git
              agenix.packages.${system}.default
              pkgs.nixfmt
              pkgs.nil
              pkgs.nixd
            ];
          };
        }
      );
    };
}
