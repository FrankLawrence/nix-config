{ config, pkgs, ... }:

{
  age.secrets.kavita = {
    file = ../secrets/kavita.age;
    owner = "kavita";
    group = "kavita";
  };

  services.kavita = {
    enable = true;
    dataDir = "/mnt/nfs/kavita/";
    tokenKeyFile = config.age.secrets.kavita.path;
    settings.Port = 5000;
  };
}
