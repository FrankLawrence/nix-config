{ config, lib, pkgs, ... }:
lib.mkIf config.services.mealie.enable {
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
      # ensureClause = {
      #   password = "";
      # }
    }];
  };

  services.mealie = {
    # port = 9000;
    port = 3060;
    listenAddress = "127.0.0.1";
    credentialsFile = config.age.secrets.mealie.path;
    settings = {
      DB_ENGINE = "postgres";
      POSTGRES_USER = "mealie";
      POSTGRES_URL_OVERRIDE = "postgresql://mealie@/mealie?host=/run/postgresql";
      # POSTGRES_PORT = 5432;
      POSTGRES_DB = "mealie";

      ALLOW_SIGNUP = true;
      OIDC_AUTH_ENABLED = true;
      OIDC_SIGNUP_ENABLED = true;
      OAUTH_PROVIDER_NAME = "Pocket ID";
      OIDC_CONFIGURATION_URL = "https://pocket-id.wurt.net/.well-known/openid-configuration";
      OIDC_USER_GROUP = "family";
      OIDC_REMEMBER_ME = true;
      OIDC_ADMIN_GROUP = "admin";
      OIDC_AUTO_REDIRECT = true;
      OIDC_PROVIDER_NAME = "Pocket-ID";

      LDAP_AUTH_ENABLED = true;
      LDAP_SERVER_URL = ldap://127.0.0.1:5051;
      LDAP_BASE_DN = "ou=people,dc=wurt,dc=net";
      LDAP_USER_FILTER = "(memberof=cn=mealie,ou=groups,dc=wurt,dc=net)";
      LDAP_ADMIN_FILTER = "(memberof=cn=lldap_admin,ou=groups,dc=wurt,dc=net)";
      LDAP_QUERY_BIND = "cn=ldap_observer,ou=people,dc=wurt,dc=net";
      LDAP_ID_ATTRIBUTE = "uid";
      LDAP_NAME_ATTRIBUTE = "cn";
      LDAP_MAIL_ATTRIBUTE = "mail";
    };
  };
}
