{ config, pkgs, ... }:

{
  # age.secrets.mealie = {
  #   file = ../../../secrets/mealie.age;
  #   owner = "mealie";
  #   group = "mealie";
  # };

  services.postgresql = {
    ensureDatabases = [ "mealie" ];
    ensureUsers = [{
      name = "mealie";
      ensureDBOwnership = true;
    }];
  };

  services.mealie = {
    # port = 9000;
    port = 3060;
    listenAddress = "127.0.0.1";
    # credentialsFile = config.age.secrets.mealie.path;
    settings = {
      DB_ENGINE = "postgres";
      POSTGRES_USER = "mealie";
      POSTGRES_SERVER = "localhost";
      POSTGRES_PORT = 5432;
      POSTGRES_DB = "mealie";
    };
  };
}
