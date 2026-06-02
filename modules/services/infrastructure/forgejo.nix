{ config, ... }:
{
  services.forgejo = {
    enable = true;
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
        HTTP_PORT = 3001;
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
}
