{ config, pkgs, lib, ... }:

{
  services.actual = {
    settings = {
      port = 3000;
      hostname = "0.0.0.0";
      dataDir = "/var/lib/actual";
    };
    openFirewall = lib.mkDefault false;
  };
}
