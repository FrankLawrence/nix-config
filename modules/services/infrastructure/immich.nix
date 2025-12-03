{ config, pkgs, ... }:

{
  age.secrets.immich = {
    file = ../../../secrets/immich.age;
    owner = "immich";
    group = "immich";
  };

  services.immich = {
    enable = lib.mkDefault false;
    port = 2283;
    mediaLocation = "/mnt/nfs/immich";
    secretsFile = config.age.secrets.immich.path;

    settings = {
      newVersionCheck.enabled = true;
      server.externalDomain = "https://immich.wurt.net";
    };

    environment = {
      UPLOAD_LOCATION = "/mnt/photo/";
    };

    host = "0.0.0.0";
  };
}
