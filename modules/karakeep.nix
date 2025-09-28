{ config, pkgs, ... }:

{
  age.secrets.karakeep = {
    file = ../secrets/karakeep.age;
  };

  services.karakeep = {
    enable = true;
    meilisearch.enable = true;
    browser = {
     enable = true;
     port = 9222;
   };
   extraEnvironment = {
     NEXTAUTH_URL = "https://karakeep.wurt.net";
     OAUTH_PROVIDER_NAME = "Pocket-ID";
   };
   environmentFile = config.age.secrets.karakeep.path;
  };
}
