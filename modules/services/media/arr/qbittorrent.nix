{ config, lib, ... }:
lib.mkIf config.services.qbittorrent.enable {
  services.qbittorrent = {
    openFirewall = true;
    webuiPort = 2052;
    profileDir = "/srv/qBittorrent/";
    serverConfig = {
	    Preferences = {
	      WebUI = {
	        Username = "frank";
	        Password_PBKDF2 = "iNYxFxS/m6qRg+zpvU767g==:vVFvZAudmUKNvkSL0HS3mZtS4vVId/qL/Yr0ObmTIDo8YgDhvDB5ukDsbAYjlaggt9oPtYHo30sb/3hZeK0XHg==";
	      };
	    };
    };
  };

  custom.glance.monitoredSites = [{
    title = "qbittorrent";
    url = "https://qbittorrent.wurt.net";
    check-url = "http://127.0.0.1:2052";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/qbittorrent.svg";
  }];
}
