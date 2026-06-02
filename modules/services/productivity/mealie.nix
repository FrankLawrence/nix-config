{ config, pkgs, ... }:

{
  age.secrets.mealie = {
    file = ../../../secrets/mealie.age;
    owner = "mealie";
    group = "mealie";
  };

  services.postgresql = {
    ensureDatabases = [ "mealie" ];
    ensureUsers = [{
      name = "mealie";
      ensureDBOwnership = true;
    }];
  };

  services.mealie = {
    enable = true;
    port = 9000;
    listenAddress = "0.0.0.0";
    credentialsFile = config.age.secrets.mealie.path;
    settings = {
      DB_ENGINE = "postgres";
      POSTGRES_USER = "mealie";
      POSTGRES_SERVER = "localhost";
      POSTGRES_PORT = 5432;
      POSTGRES_DB = "mealie";
    };
  };
}
