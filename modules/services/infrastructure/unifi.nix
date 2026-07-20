{ config, lib, ... }:
lib.mkIf config.services.unifi.enable {
  services.unifi = {
    openFirewall = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "unifi-controller"
  ];
}
