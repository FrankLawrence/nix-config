{ config, lib, ... }:
lib.mkIf config.services.kavita.enable {
  age.secrets.kavita = {
    file = ../../../secrets/kavita.age;
    owner = "kavita";
    group = "kavita";
  };

  services.kavita = {
    tokenKeyFile = config.age.secrets.kavita.path;
    # settings.Port = 5000;
    settings.Port = 2010;
    settings.IpAddresses = "127.0.0.1";
  };

  custom.glance.monitoredSites = [{
    title = "Kavita";
    url = "https://kavita.wurt.net";
    check-url = "http://127.0.0.1:5000";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/kavita.svg";
  }];
}
