{ config, lib, pkgs, ... }:
lib.mkIf config.services.freshrss.enable {
	services.postgresql = {
    ensureDatabases = [ "freshrss" ];
    ensureUsers = [{
      name = "freshrss";
      ensureDBOwnership = true;
    }];
  };

  age.secrets.freshrss = {
    file = ../../../secrets/freshrss.age;
    owner = "freshrss";
    group = "freshrss";
  };
  age.secrets.freshrss-secret = {
    file = ../../../secrets/freshrss-secret.age;
    owner = "freshrss";
    group = "freshrss";
  };

	services.freshrss = {
		webserver = "caddy";
		database = {
			type = "pgsql";
			user = "freshrss";
			name = "freshrss";
			host = "/run/postgresql";
			# port = 5432;
		};

		passwordFile = config.age.secrets.freshrss-secret.path;
		baseUrl = "https://freshrss.wurt.net";
	};

  services.phpfpm.pools.freshrss = {
    phpEnv = {
      OIDC_ENABLED = "1";
      OIDC_PROVIDER_METADATA_URL = "https://pocket-id.wurt.net/.well-known/openid-configuration";
      OIDC_SCOPES = "openid email profile";
      OIDC_X_FORWARDED_HEADERS = "X-Forwarded-Proto X-Forwarded-Host";
      OIDC_REMOTE_USER_CLAIM = "preferred_username";
    };
    # Allow workers to inherit OIDC_CLIENT_ID and OIDC_CLIENT_SECRET from the
    # service environment (injected below via EnvironmentFile) without exposing
    # them in the Nix store.
    settings."clear_env" = "no";
  };

  # Inject client credentials from agenix secret into the phpfpm service
  # environment; clear_env=no above makes them visible to PHP workers.
  systemd.services.phpfpm-freshrss.serviceConfig.EnvironmentFile =
    config.age.secrets.freshrss.path;
}
