{ config, lib, pkgs, inputs, ... }:
let
  # 26.05 is stuck on 1.7.5; use the package and module from unstable
  unstable = inputs.nixpkgs-unstable;
  unstablePkgs = unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  disabledModules = [ "services/web-apps/dawarich.nix" ];
  imports = [ "${unstable}/nixos/modules/services/web-apps/dawarich.nix" ];

  config = lib.mkIf config.services.dawarich.enable {
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
      ensureUsers = [
        {
          name = "dawarich";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers."dawarich" = {
      enable = true;
      port = 4011;
    };

    services.dawarich = {
      package = unstablePkgs.dawarich;
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
        OIDC_ISSUER = "https://id.wurt.net";
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

    custom.glance.monitoredSites = [
      {
        title = "Dawarich";
        url = "https://dawarich.wurt.net";
        check-url = "http://127.0.0.1:4010/api/v1/health";
        icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/dawarich.svg";
      }
    ];
  };
}
