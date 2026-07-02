{ config, lib, pkgs, ... }:
{
  age.secrets.pocket-id = {
    file = ../../../secrets/pocket-id.age;
    owner = "pocket-id";
    group = "pocket-id";
  };

  services.postgresql = {
    ensureDatabases = [ "pocket-id" ];
    ensureUsers = [{
      name = "pocket-id";
      ensureDBOwnership = true;
    }];
  };

  services.pocket-id = {
    environmentFile = config.age.secrets.pocket-id.path;
    settings = {
      ANALYTICS_DISABLED = true;
      APP_URL = "https://pocket-id.wurt.net";
      DB_PROVIDER = "postgres";
      DB_CONNECTION_STRING = "postgresql://pocket-id@pocket-id?host=/run/postgresql";
      TRUST_PROXY = false;
      # PORT = 1411;
      PORT = 5010;
      HOST = "127.0.0.1";
      METRICS_ENABLED = true;
      OTEL_METRICS_EXPORTER = "prometheus";
      OTEL_EXPORTER_PROMETHEUS_PORT = 5073;
    };
  };

  custom.glance.monitoredSites = lib.mkIf config.services.pocket-id.enable [{
    title = "Pocket ID";
    url = "https://pocket-id.wurt.net";
    check-url = "http://127.0.0.1:1411";
    icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/pocket-id.svg";
  }];
}
