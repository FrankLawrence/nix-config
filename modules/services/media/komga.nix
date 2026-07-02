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

  custom.glance.monitoredSites = lib.mkIf config.services.komga.enable [{
    title = "Komga";
    url = "https://komga.wurt.net";
    check-url = "http://127.0.0.1:8082";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/komga.svg";
  }];
}
