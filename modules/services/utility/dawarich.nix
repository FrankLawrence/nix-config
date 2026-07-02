{ config, lib, ... }:
lib.mkIf config.services.dawarich.enable {
  age.secrets.dawarich = {
    file = ../../../secrets/dawarich.age;
    owner = "dawarich";
  };

  age.secrets.dawarich-secret-key = {
    file = ../../../secrets/dawarich-secret-key.age;
    owner = "dawarich";
  };

  services.postgresql = {
    ensureDatabases = [ "dawarich" ];
    ensureUsers = [{
      name = "dawarich";
      ensureDBOwnership = true;
    }];
  };

  services.redis.servers."dawarich" = {
    enable = true;
    port = 4011;
  };

  services.dawarich = {
    database = {
      host = "/run/postgresql";
      name = "dawarich";
      user = "dawarich";
    };
    redis = {
      host = "localhost";
      port = 4011;
    };

    webPort = 4010;
    localDomain = "dawarich.wurt.net";
    configureNginx = false;
    environment = {
      APPLICATION_HOSTS = "127.0.0.1,dawarich.wurt.net";
      APPLICATION_PROTOCOL = "https";
      DOMAIN = "dawarich.wurt.net";
      OIDC_ISSUER = "https://pocket-id.wurt.net";
      OIDC_REDIRECT_URI = "https://dawarich.wurt.net/users/auth/openid_connect/callback";
      OIDC_PROVIDER_NAME = "Pocket-ID";
      OIDC_AUTO_REGISTER = "true";
      OIDC_PKCE_ENABLED = "true";
      ALLOW_EMAIL_PASSWORD_REGISTRATION = "false";
      SELF_HOSTED = "true";
    };
    extraEnvFiles = [
    	config.age.secrets.dawarich.path
    ];
    secretKeyBaseFile = config.age.secrets.dawarich-secret-key.path;
  };

  custom.glance.monitoredSites = [{
    title = "Dawarich";
    url = "https://darawich.wurt.net";
    check-url = "http://127.0.0.1:3000";
    icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/dawarich.svg";
  }];
}
