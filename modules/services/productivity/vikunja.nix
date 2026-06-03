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
      host = "/run/postgresql";
      user = "vikunja";
      database = "vikunja";
    };
    settings = {
    	auth = {
        openid = {
        	enabled = true;
          redirecturl = "https://vikunja.wurt.net/auth/openid/pocketid";
          providers = {
            PocketID = {
	            name = "PocketID";
							usernamefallback = true;
			        emailfallback = true;
              authurl = "https://pocket-id.wurt.net";
              clientID = "f4e6ada2-a852-4dbe-b45c-d4c28faf9731";
              clientsecret = "l7BqDa9O8xLMWoGQltMGtBSIW85UqSzM";
              scope = "openid profile email";
            };
          };
        };
      };
    };
  };
}
