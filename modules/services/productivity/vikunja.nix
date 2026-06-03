{ config, ... }:
{
  services.postgresql = {
    ensureDatabases = [ "vikunja" ];
    ensureUsers = [{
      name = "vikunja";
      ensureDBOwnership = true;
    }];
  };

  services.vikunja = {
    frontendScheme = "https";
    frontendHostname = "vikunja.wurt.net";
    database = {
      type = "postgres";
      host = "127.0.0.1";
      user = "vikunja";
      database = "vikunja";
    };
  };
}
