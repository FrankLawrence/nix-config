{
  services.postgresql = {
    ensureDatabases = [ "suwayomi" ];
    ensureUsers = [{
      name = "suwayomi";
      ensureDBOwnership = true;
    }];
  };

  services.suwayomi-server = {
    settings.server = {
      ip = "127.0.0.1";
      port = 2060;
      localSourcePath = "/srv/library/manga";
      downloadAsCbz = true;
    };
  };
}
