{ config, ... }:
{
  age.secrets.oauth2-proxy = {
    file = ../../../secrets/oauth2-proxy.age;
    owner = "oauth2-proxy";
  };

  services.oauth2-proxy = {
    enable = true;
    provider = "oidc";
    clientID = "homelab";
    keyFile = config.age.secrets.oauth2-proxy.path;
    upstream = "static://202";
    oidcIssuerUrl = "https://pocket-id.wurt.net";
    httpAddress = "127.0.0.1:4180";
    email.domains = [ "*" ];
    cookie.domain = ".wurt.net";
    redirectUrl = "https://auth.wurt.net/oauth2/callback";
    reverseProxy = true;
    setXauthrequest = true;
    loginUrl = "https://pocket-id.wurt.net";

    cookie.secure = true;
    cookie.name = "__Host-oauth2-proxy";

    extraConfig = {
      whitelist-domain    = ".wurt.net";
      skip-provider-button = true;
    };
  };
}
