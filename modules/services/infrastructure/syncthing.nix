{ config, lib, ... }:
lib.mkIf config.services.syncthing.enable {
  services.syncthing = {
    user = "frank";
    group = "users";
    dataDir = "/home/frank";
    configDir = "/home/frank/.config/syncthing";
    guiAddress = "127.0.0.1:5040";
    openDefaultPorts = true;
    settings = import ../../shared/syncthing.nix;
  };
}
