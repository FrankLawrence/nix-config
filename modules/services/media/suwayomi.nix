{ config, lib, ... }:
{
  services.postgresql = {
    ensureDatabases = [ "suwayomi" ];
    ensureUsers = [{
      name = "suwayomi";
      ensureDBOwnership = true;
    }];
  };

  services.suwayomi-server = {
    group = "nfs-shared";
    openFirewall = true;
    dataDir = "/srv/suwayomi/";
    settings = {
      ip = "127.0.0.1";
      port = 2060;

      downloadAsCbz = true;
      downloadsPath = "/mnt/nfs/manga/";
      autoDownloadNewChapters = true;

      databaseType = "POSTGRESQL";
      databaseUrl = "postgresql://host=/run/postgresql";
      databaseUsername = "suwayomi";

      initialOpenInBrowserEnabled = false;
      systemTrayEnabled = false;
    };
  };
}
