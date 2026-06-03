{ config, ... }:
{
  # age.secrets.syncthing = {
  #   file = ../../../secrets/syncthing.age;
  #   owner = "syncthing";
  #   group = "syncthing";
  # };
  services.syncthing = {
    group = "users";
    user = "frank";
    dataDir = "/home/frank/";
    configDir = "/home/frank/.config/syncthing";
    # guiAddress = "127.0.0.1:8384";
    guiAddress = "127.0.0.1:1040";
    settings.devices = {
      jupiter = {
        name = "jupiter";
        # id = config.age.secrets.syncthing.path;
      };
    };
  };
}
