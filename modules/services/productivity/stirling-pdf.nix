{ config, pkgs, ... }:

{
  services.stirling-pdf = {
    environment = {
      # SERVER_PORT = 8081;
      SERVER_PORT = 3010;
      SERVER_HOST = "127.0.0.1";
    };
  };

  custom.glance.monitoredSites = lib.mkIf config.services.stirling-pdf.enable [{
    title = "Stirling PDF";
    url = "https://stirling-pdf.wurt.net";
    check-url = "http://127.0.0.1:8081";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/stirling-pdf.svg";
  }];
}
