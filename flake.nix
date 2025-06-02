 {
   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
   };
 
   outputs = { nixpkgs, ... }: {
     nixosConfigurations = {
       hetzner = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [
           ./hosts/hetzner/configuration.nix
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
