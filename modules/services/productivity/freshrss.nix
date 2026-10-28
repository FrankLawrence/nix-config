{ config, lib, ... }:
lib.mkIf config.services.freshrss.enable {
	services.postgresql = {
    ensureDatabases = [ "freshrss" ];
    ensureUsers = [{
      name = "freshrss";
      ensureDBOwnership = true;
    }];
  };

  # Password for the FreshRSS user. FreshRSS's OIDC_* variables only work in its
  # Docker image (Apache + mod_auth_openidc), not behind caddy + php-fpm.
  age.secrets.freshrss-secret = {
    file = ../../../secrets/freshrss-secret.age;
    owner = "freshrss";
    group = "freshrss";
  };

	services.freshrss = {
		webserver = "caddy";
		# The module serves php-fpm from this caddy vhost itself; nothing listens on a port
		virtualHost = "freshrss.wurt.net";
		database = {
			type = "pgsql";
			user = "freshrss";
			name = "freshrss";
			host = "/run/postgresql";
			# port = 5432;
		};

		defaultUser = "frank";
		passwordFile = config.age.secrets.freshrss-secret.path;
		baseUrl = "https://freshrss.wurt.net";
	};
}
