{ config, lib, ... }:
lib.mkIf config.services.slskd.enable {
  age.secrets.slskd = {
    file = ../../../secrets/slskd.age;
    owner = "slskd";
    group = "slskd";
  };

  services.slskd = {
    environmentFile = config.age.secrets.slskd.path;
  	domain = "slskd.wurt.net";
    settings = {
    	shares.directories = [ "/mnt/nfs/music" ];
     	web = {
      	port = 2051;
        ip_address = "[::]";
      };
    };
  };

  custom.glance.monitoredSites = [{
    title = "slskd";
    url = "https://slskd.wurt.net";
    check-url = "http://127.0.0.1:2051";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/slskd.svg";
  }];
}
