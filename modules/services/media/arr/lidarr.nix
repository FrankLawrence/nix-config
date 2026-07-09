{ config, lib, ... }:
lib.mkIf config.services.lidarr.enable {
  # age.secrets.lidarr = {
  #   file = ../../../secrets/lidarr.age;
  #   owner = "lidarr";
  #   group = "lidarr";
  # };

  services.lidarr = {
    # environmentFiles = [ config.age.secrets.lidarr.path ];
    openFirewall = true;
    settings = {
	    server.port = 2050;
			server.bindaddress = "127.0.0.1";
    };
  };

  custom.glance.monitoredSites = [{
    title = "lidarr";
    url = "https://lidarr.wurt.net";
    check-url = "http://127.0.0.1:2050";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/lidarr.svg";
  }];
}
