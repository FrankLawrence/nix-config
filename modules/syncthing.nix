{ config, ... }:
{
  age.secrets.syncthing = {
    file = ../secrets/syncthing.age;
    owner = "syncthing";
    group = "syncthing";
  };
  services.syncthing = {
    enable = true;
    group = "users";
    user = "pinkfloyd";
    dataDir = "/home/pinkfloyd/";
    configDir = "/home/pinkfloyd/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
    settings.devices = {
      jupiter = {
        name = "jupiter";
        id = config.age.secrets.syncthing.path;
      };
    };
  };
}
