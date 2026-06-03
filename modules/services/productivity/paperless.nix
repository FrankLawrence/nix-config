{ config, ... }:
{
  # age.secrets.paperless-admin = {
  #   file = ../../../secrets/paperless-admin.age;
  #   owner = "paperless";
  # };

  services.postgresql = {
    ensureDatabases = [ "paperless" ];
    ensureUsers = [{
      name = "paperless";
      ensureDBOwnership = true;
    }];
  };

  services.paperless = {
    port = 28981;
    address = "127.0.0.1";
    # passwordFile = config.age.secrets.paperless-admin.path;
    settings = {
      PAPERLESS_URL = "https://paperless.wurt.net";
      PAPERLESS_ADMIN_USER = "admin";
      PAPERLESS_DBENGINE = "postgresql";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DBNAME = "paperless";
      PAPERLESS_DBUSER = "paperless";
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_CONSUMER_POLLING = 60;
    };
  };
}
