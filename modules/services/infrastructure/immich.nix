{ config, lib, pkgs, ... }:

{
  # age.secrets.immich = {
  #   file = ../../../secrets/immich.age;
  #   owner = "immich";
  #   group = "immich";
  # };

  services.immich = {
    # port = 2283;
    port = 1030;
    mediaLocation = "/mnt/nfs/immich";
    # secretsFile = config.age.secrets.immich.path;

    settings = {
      newVersionCheck.enabled = true;
      server.externalDomain = "https://immich.wurt.net";
    };

    environment = {
      UPLOAD_LOCATION = "/mnt/photo/";
    };

    host = "127.0.0.1";
  };

  custom.glance.monitoredSites = lib.mkIf config.services.immich.enable [{
    title = "Immich";
    url = "https://immich.wurt.net";
    check-url = "http://127.0.0.1:2283";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg";
  }];
}
