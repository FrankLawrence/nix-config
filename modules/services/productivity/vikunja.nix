{ config, lib, ... }:
lib.mkIf config.services.vikunja.enable {
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
    	metrics.enabled = true;
    	auth = {
        openid = {
        	enabled = true;
          redirecturl = "https://vikunja.wurt.net/auth/openid/pocketid";
          providers = {
            PocketID = {
	            name = "PocketID";
							usernamefallback = true;
			        emailfallback = true;
              authurl = "https://id.wurt.net";
              clientID = "";
              clientsecret = "";
              scope = "openid profile email";
            };
          };
        };
      };
    };
  };

  custom.glance.monitoredSites = [{
    title = "Vikunja";
    url = "https://vikunja.wurt.net";
    check-url = "http://127.0.0.1:3030";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/vikunja.png";
  }];
}
