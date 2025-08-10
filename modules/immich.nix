{ config, pkgs, ... }:

{
  services.immich = {
    enable = true;
    openFirewall = true;
    mediaLocation = "/mnt/nfs/immich";

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
