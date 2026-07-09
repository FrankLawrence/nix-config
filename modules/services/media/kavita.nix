{ config, lib, pkgs, ... }:
lib.mkIf config.services.kavita.enable {
  age.secrets.kavita = {
    file = ../../../secrets/kavita.age;
    owner = "kavita";
    group = "kavita";
  };

  services.kavita = {
    dataDir = "/srv/kavita/";
    tokenKeyFile = config.age.secrets.kavita.path;
    # settings.Port = 5000;
    settings.Port = 2010;
  };

  custom.glance.monitoredSites = [{
    title = "Kavita";
    url = "https://kavita.wurt.net";
    check-url = "http://127.0.0.1:5000";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/kavita.svg";
  }];

  networking.firewall.allowedTCPPorts = [ config.services.kavita.settings.Port ];
}
