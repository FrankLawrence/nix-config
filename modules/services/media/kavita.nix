{ config, lib, pkgs, ... }:
lib.mkIf config.services.kavita.enable {
  age.secrets.kavita = {
    file = ../../../secrets/kavita.age;
    owner = "kavita";
    group = "kavita";
  };
  # Raw Pocket-ID client secret
  age.secrets.kavita-oidc = {
    file = ../../../secrets/kavita-oidc.age;
    owner = "kavita";
    group = "kavita";
  };

  services.kavita = {
    tokenKeyFile = config.age.secrets.kavita.path;
    settings = {
      Port = 2010;
      IpAddresses = "127.0.0.1";
      OpenIdConnectSettings = {
        Authority = "https://id.wurt.net";
        ClientId = "6b33a4fb-dba7-442d-909a-72642f881b57";
        Secret = "@OIDC_SECRET@";
        CustomScopes = [ ];
        Enabled = true;
      };
    };
  };

  systemd.services.kavita = {
    serviceConfig.LoadCredential = [ "oidc-secret:${config.age.secrets.kavita-oidc.path}" ];
    preStart = lib.mkAfter ''
      ${pkgs.replace-secret}/bin/replace-secret '@OIDC_SECRET@' \
        ''${CREDENTIALS_DIRECTORY}/oidc-secret \
        '${config.services.kavita.dataDir}/config/appsettings.json'
    '';
  };

  custom.glance.monitoredSites = [
    {
      title = "Kavita";
      url = "https://kavita.wurt.net";
      check-url = "http://127.0.0.1:2010";
      icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/kavita.svg";
    }
  ];
}

