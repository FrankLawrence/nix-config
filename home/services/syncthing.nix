{ ... }:
{
  services.syncthing = {
    enable = true;
    settings = import ../../modules/shared/syncthing.nix;
  };
}
