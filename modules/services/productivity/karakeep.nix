{ config, pkgs, ... }:

{
  services.karakeep = {
    meilisearch.enable = true;
    browser = {
     enable = true;
     port = 9222;
   };
   extraEnvironment = {
     NEXTAUTH_URL = "https://karakeep.wurt.net";
     OAUTH_PROVIDER_NAME = "Pocket-ID";
   };
  };
}
