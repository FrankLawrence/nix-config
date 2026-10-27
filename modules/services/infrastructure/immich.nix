{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # Immich 2.x on 26.05 is EOL and marked insecure; use the 3.x package and module from unstable
  unstable = inputs.nixpkgs-unstable;
  unstablePkgs = unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  disabledModules = [ "services/web-apps/immich.nix" ];
  imports = [ "${unstable}/nixos/modules/services/web-apps/immich.nix" ];

  config = lib.mkIf config.services.immich.enable {
    age.secrets.immich-oidc.file = ../../../secrets/immich-oidc.age;

    services.immich = {
      package = unstablePkgs.immich;
      port = 2070;
      # Phone uploads stay on the local disk and are backed up to the NAS by restic.
      # The NAS photo share is read-only, added in the UI as an external library at /mnt/photo
      mediaLocation = "/var/lib/immich";

      settings = {
        newVersionCheck.enabled = true;
        server.externalDomain = "https://immich.wurt.net";
        oauth = {
          enabled = true;
          issuerUrl = "https://id.wurt.net";
          clientId = "d7712d50-a75b-446b-9e38-5a74ff1f8faf";
          clientSecret._secret = config.age.secrets.immich-oidc.path;
          scope = "openid email profile";
          buttonText = "Login with Pocket-ID";
          autoRegister = true;
          autoLaunch = false;
          # Pocket-ID custom claim on the admins group: immich_role = admin
          roleClaim = "immich_role";
          storageLabelClaim = "preferred_username";
          storageQuotaClaim = "immich_quota";
          signingAlgorithm = "RS256";
          profileSigningAlgorithm = "none";
          tokenEndpointAuthMethod = "client_secret_post";
          mobileOverrideEnabled = false;
        };
	machineLearning.urls = [ "http://100.89.96.126:3003" "http://localhost:3003" ];
        passwordLogin.enabled = false;
      };

      host = "127.0.0.1";
    };

    # Wait for the NAS so the external library is readable
    systemd.services.immich-server = {
      after = [ "remote-fs.target" ];
      wants = [ "remote-fs.target" ];
    };

    custom.glance.monitoredSites = [
      {
        title = "Immich";
        url = "https://immich.wurt.net";
        check-url = "http://127.0.0.1:2070";
        icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg";
      }
    ];
  };
}
