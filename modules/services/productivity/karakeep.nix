{ config, lib, pkgs, ... }:
lib.mkIf config.services.karakeep.enable {
  age.secrets.karakeep = {
    file = ../../../secrets/karakeep.age;
    owner = "karakeep";
    group = "karakeep";
  };

  services.karakeep = {
    meilisearch.enable = true;
    browser = {
     enable = true;
     # port = 9222;
    };
    environmentFile = config.age.secrets.karakeep.path;
    extraEnvironment = {
     NEXTAUTH_URL = "https://karakeep.wurt.net";
     DISABLE_PASSWORD_AUTH = "true";
     OAUTH_AUTO_REDIRECT = "true";
     OAUTH_WELLKNOWN_URL = "https://pocket-id.wurt.net/.well-known/openid-configuration";
     OAUTH_PROVIDER_NAME = "Pocket-ID";
     OAUTH_ALLOW_DANGEROUS_EMAIL_ACCOUNT_LINKING = "true";
     PORT = "3050";
   };
  };
}
