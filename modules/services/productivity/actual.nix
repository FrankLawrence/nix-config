{ config, pkgs, lib, ... }:

{
  services.actual = {
    settings = {
      # port = 3000;
      port = 3040;
      hostname = "127.0.0.1";
      dataDir = "/var/lib/actual";
    };
    openFirewall = lib.mkDefault false;
  };
}
