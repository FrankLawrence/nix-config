{ config, pkgs, lib, ... }:
lib.mkIf config.services.actual.enable {
  services.actual = {
    settings = {
      # port = 3000;
      port = 3040;
      hostname = "127.0.0.1";
      dataDir = "/var/lib/actual";
    };
    openFirewall = true;
  };
}
