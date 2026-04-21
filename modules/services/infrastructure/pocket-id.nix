{ config, pkgs, ... }:
{
  age.secrets.pocket-id = {
    file = ../../../secrets/pocket-id.age;
    owner = "pocket-id";
    group = "pocket-id";
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "pocket-id" ];
    ensureUsers = [{
      name = "pocket-id";
      ensureDBOwnership = true;
    }];
  };

  services.pocket-id = {
    enable = true;
    environmentFile = config.age.secrets.pocket-id.path;
    settings = {
      ANALYTICS_DISABLED = true;
      # APP_URL = "https://pocket-id.wurt.net";
      APP_URL = "http://centauri.tailc21299.ts.net:1411";
      DB_CONNECTION_STRING = "postgresql://pocket-id@localhost:5432/pocket-id";
      TRUST_PROXY = false;
      PORT = 1411;
      HOST = "0.0.0.0";
    };
  };
}
