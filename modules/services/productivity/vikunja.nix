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
    # port = 3456;
    port = 3030;
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
