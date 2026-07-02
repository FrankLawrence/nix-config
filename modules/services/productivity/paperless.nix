{ config, lib, ... }:
lib.mkIf config.services.paperless.enable {
  age.secrets.paperless = {
    file = ../../../secrets/paperless.age;
    owner = "paperless";
  };
  age.secrets.paperless-oidc = {
    file = ../../../secrets/paperless-oidc.age;
    owner = "paperless";
  };

  services.paperless = {
    port = 3020;
    address = "127.0.0.1";
    # passwordFile = config.age.secrets.paperless.path;
    database.createLocally = true;
    environmentFile = config.age.secrets.paperless-oidc.path;
    settings = {
      PAPERLESS_URL = "https://paperless.wurt.net";
      PAPERLESS_ADMIN_USER = "admin";
      PAPERLESS_ACCOUNT_ALLOW_SIGNUPS = true;

      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_CONSUMER_POLLING = 60;
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
      PAPERLESS_DISABLE_REGULAR_LOGIN = false;
      PAPERLESS_REDIRECT_LOGIN_TO_SSO = false;
    };
  };

  custom.glance.monitoredSites = [{
    title = "Paperless-NGX";
    url = "https://paperless.wurt.net";
    check-url = "http://127.0.0.1:28981";
    icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/paperless-ngx.svg";
  }];
}
