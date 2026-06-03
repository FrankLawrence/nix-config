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
    dontBuild  = true;

    installPhase = ''
      install -Dm755 $src $out/bin/tinyauth
    '';
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
  users.groups.tinyauth = {};

  systemd.services.tinyauth = {
    description = "Tinyauth forward-auth middleware";
    after    = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart        = "${tinyauth}/bin/tinyauth";
      User             = "tinyauth";
      Group            = "tinyauth";
      EnvironmentFile  = config.age.secrets.tinyauth.path;
      WorkingDirectory = "/var/lib/tinyauth";
      StateDirectory   = "tinyauth";
      Restart          = "on-failure";
      RestartSec       = "5s";

      # Hardening
      NoNewPrivileges       = true;
      ProtectSystem         = "strict";
      ProtectHome           = true;
      PrivateTmp            = true;
      PrivateDevices        = true;
      CapabilityBoundingSet = "";
      ReadWritePaths        = [ "/var/lib/tinyauth" ];
    };
  };
}

