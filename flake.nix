 {
   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
     agenix.url = "github:ryantm/agenix";
     agenix.inputs.nixpkgs.follows = "nixpkgs";
   };

   outputs = { self, nixpkgs, agenix, ... }@inputs: {
     nixosConfigurations = {
       hetzner = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         specialArgs = {
           inherit inputs;
         };
         modules = [
           ./hosts/hetzner/configuration.nix
           agenix.nixosModules.default
         ];
       };
       homelab = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         specialArgs = {
           inherit inputs;
         };
         modules = [
           ./hosts/homelab/configuration.nix
           agenix.nixosModules.default
         ];
       };
     };
   };
 }
