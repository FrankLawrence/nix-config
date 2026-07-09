{ config, lib, ... }:
lib.mkIf config.services.forgejo.enable {
  services.forgejo = {
    database = {
      type = "postgres";
      # createDatabase handles ensureDatabases + ensureUsers via NixOS PostgreSQL module
      createDatabase = true;
    };
    settings = {
      DEFAULT = {
        APP_NAME = "Forgejo";
      };
      server = {
        DOMAIN = "forgejo.wurt.net";
        # HTTP_PORT = 3001;
        HTTP_PORT = 1020;
        ROOT_URL = "https://forgejo.wurt.net/";
        SSH_DOMAIN = "forgejo.wurt.net";
        # SSH_PORT = 2222;
        SSH_PORT = 1021;
        START_SSH_SERVER = true;
      };
      service = {
        # First user to register becomes admin; disable afterwards
        DISABLE_REGISTRATION = true;
      };
      security = {
        LOGIN_REMEMBER_DAYS = 14;
      };
    };
  };

  custom.glance.monitoredSites = lib.mkIf config.services.forgejo.enable [{
    title = "Forgejo";
    url = "https://forgejo.wurt.net";
    check-url = "http://127.0.0.1:3001";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/forgejo.svg";
  }];
}
