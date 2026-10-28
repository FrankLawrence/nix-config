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
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 5020;
        ROOT_URL = "https://forgejo.wurt.net/";
        SSH_DOMAIN = "forgejo.wurt.net";
        SSH_PORT = 2222;
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

  # git clone ssh://forgejo@forgejo.wurt.net:2222/<user>/<repo>.git
  networking.firewall.allowedTCPPorts = [ 2222 ];

  custom.glance.monitoredSites = lib.mkIf config.services.forgejo.enable [{
    title = "Forgejo";
    url = "https://forgejo.wurt.net";
    check-url = "http://127.0.0.1:5020";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/forgejo.svg";
  }];
}
