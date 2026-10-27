{ config, lib, pkgs, ... }:
let
  version = "5.0.7";

  tinyauth = pkgs.stdenv.mkDerivation {
    pname = "tinyauth";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/tinyauthapp/tinyauth/releases/download/v5.0.7/tinyauth-amd64";
      hash = "sha256:4f9b97c003369df1a7fe9529f30ca6349b1ad183c368fa7a649cb964e7b1e617";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.glibc ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      install -Dm755 $src $out/bin/tinyauth
    '';
  };

  appGroups = {
    adguard = "admins";
    grafana = "admins";
    lidarr = "admins";
    navidrome = "family";
    qbittorrent = "admins";
    suwayomi = "admins";
  };
in
{
  age.secrets.tinyauth = {
    file = ../../../secrets/tinyauth.age;
    owner = "tinyauth";
  };

  users.users.tinyauth = {
    isSystemUser = true;
    group = "tinyauth";
  };
  users.groups.tinyauth = { };

  systemd.services.tinyauth = {
    description = "Tinyauth forward-auth middleware";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      TINYAUTH_APPURL = "https://auth.wurt.net";
      TINYAUTH_SERVER_ADDRESS = "127.0.0.1";
      TINYAUTH_SERVER_PORT = "5000";
      TINYAUTH_DATABASE_PATH = "/var/lib/tinyauth/tinyauth.db";
      TINYAUTH_AUTH_SECURECOOKIE = "true";
      TINYAUTH_OAUTH_AUTOREDIRECT = "pocketid";
      TINYAUTH_OAUTH_PROVIDERS_POCKETID_NAME = "Pocket-ID";
      TINYAUTH_OAUTH_PROVIDERS_POCKETID_AUTHURL = "https://id.wurt.net/authorize";
      TINYAUTH_OAUTH_PROVIDERS_POCKETID_TOKENURL = "https://id.wurt.net/api/oidc/token";
      TINYAUTH_OAUTH_PROVIDERS_POCKETID_USERINFOURL = "https://id.wurt.net/api/oidc/userinfo";
      TINYAUTH_OAUTH_PROVIDERS_POCKETID_REDIRECTURL = "https://auth.wurt.net/api/oauth/callback/pocketid";
      TINYAUTH_OAUTH_PROVIDERS_POCKETID_SCOPES = "openid email profile groups";
    }
    # Only these LLDAP groups (via Pocket-ID's groups claim) may open each app.
    # The app ID is the subdomain caddy forwards for.
    // lib.concatMapAttrs (app: groups: {
      "TINYAUTH_APPS_${lib.toUpper app}_CONFIG_DOMAIN" = "${app}.wurt.net";
      "TINYAUTH_APPS_${lib.toUpper app}_OAUTH_GROUPS" = groups;
    }) appGroups;

    serviceConfig = {
      ExecStart = "${tinyauth}/bin/tinyauth";
      User = "tinyauth";
      Group = "tinyauth";
      EnvironmentFile = config.age.secrets.tinyauth.path;
      WorkingDirectory = "/var/lib/tinyauth";
      StateDirectory = "tinyauth";
      Restart = "on-failure";
      RestartSec = "5s";

      # Hardening
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      CapabilityBoundingSet = "";
      ReadWritePaths = [ "/var/lib/tinyauth" ];
    };
  };
}
