{ config, pkgs, ...}:

{
  age.secrets.mealie = {
    file = ../secrets/mealie.age;
    owner = "mealie";
    group = "mealie";
  };

  services.mealie = {
    enable = true;
    port = 9000;
    listenAddress = "0.0.0.0";
    credentialsFile = config.age.secrets.mealie.path;
  };
}
