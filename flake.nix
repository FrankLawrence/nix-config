 {
   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
     inputs.agenix.url = "github:ryantm/agenix";
   };

   outputs = { self, nixpkgs, agenix, ... }: {
     nixosConfigurations = {
       hetzner = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [
           ./hosts/hetzner/configuration.nix
           agenix.nixosModules.default
         ];
       };
       homelab = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [
           ./hosts/homelab/configuration.nix
         ];
       };
     };
   };
 }
