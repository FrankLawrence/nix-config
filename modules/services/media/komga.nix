{ config, lib, ... }:
lib.mkIf config.services.komga.enable {
  services.komga = {
    settings = {
      # server.port = 8082;
      server.port = 2020;
      komga.oauth2-account-creation = true;
    };

    stateDir = "/var/lib/komga";
    openFirewall = true;
  };
}
