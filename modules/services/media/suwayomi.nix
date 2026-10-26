{
  services.postgresql = {
    ensureDatabases = [ "suwayomi" ];
    ensureUsers = [{
      name = "suwayomi";
      ensureDBOwnership = true;
    }];
  };

  services.suwayomi-server = {
    openFirewall = true;
    settings.server = {
      ip = "0.0.0.0";
      port = 2060;
      localSourcePath = "/srv/library/manga";
      downloadAsCbz = true;
    };
  };
}
