{ config, lib, pkgs, ... }:
lib.mkIf config.services.pgadmin.enable {
	age.secrets.pgadmin = {
    file = ../../../secrets/pgadmin.age;
    owner = "pgadmin";
    group = "pgadmin";
  };
  age.secrets.lldap-observer = {
     file = ../../../secrets/lldap-observer.age;
  };

  services.postgresql = {
    ensureDatabases = [ "pgadmin" ];
    ensureUsers = [{
      name = "pgadmin";
      ensureDBOwnership = true;
    }];
  };


	services.pgadmin = {
		initialEmail = "admin@wurt.net";
		initialPasswordFile = config.age.secrets.pgadmin.path;
		port = 5060;
		settings = {
			CONFIG_DATABASE_URI = "postgresql://pgadmin@/pgadmin?host=/run/postgresql";

			# LDAP
			AUTHENTICATION_SOURCES = [ "oauth2" "ldap" "internal"];
			LDAP_SERVER_URI = "ldap://localhost:5051";
			LDAP_AUTO_CREATE_USER = true;
			LDAP_USERNAME_ATTRIBUTE = "uid";
			LDAP_SEARCH_BASE_DN = "ou=people,dc=wurt,dc=net";
			LDAP_SEARCH_FILTER = "(memberof=cn=lldap_admin,ou=groups,dc=wurt,dc=net)";
			LDAP_BASE_DN = "ou=people,dc=wurt,dc=net";
      LDAP_BIND_USER = "uid=ldap_observer,ou=people,dc=wurt,dc=net";

      # OIDC
      OAUTH2_AUTO_CREATE_USER = true;
      OAUTH2_CONFIG = [{
	      OAUTH2_NAME = "Pocket-ID";
	      OAUTH2_DISPLAY_NAME = "Pocket-ID";
	      OAUTH2_TOKEN_URL = "https://pocket-id.wurt.net/api/oidc/token";
	      OAUTH2_AUTHORIZATION_URL = "https://pocket-id.wurt.net/authorize";
	      OAUTH2_API_BASE_URL = "https://pocket-id.wurt.net";
	      OAUTH2_USERINFO_ENDPOINT = "https://pocket-id.wurt.net/api/oidc/userinfo";
	      OAUTH2_SERVER_METADATA_URL = "https://pocket-id.wurt.net/.well-known/openid-configuration";
	      OAUTH2_SCOPE = "openid email profile";
	      OAUTH2_ICON = "fa-openid";
	      OAUTH2_BUTTON_COLOR = "#fd4b2d";
				OAUTH2_CLIENT_SECRET = "g3aRMkexKRUFvoKY4BmsBzEuMIN9oUrg";
				OAUTH2_CLIENT_ID = "60489797-7d56-4177-87c5-26c20bf40fad";
		    OAUTH2_RESPONSE_TYPE = "code";
	      OAUTH2_CHALLENGE_METHOD = "S256";
      }];
		};
	};

 systemd.services.pgadmin4.serviceConfig.EnvironmentFile =
    config.age.secrets.lldap-observer.path;

}
