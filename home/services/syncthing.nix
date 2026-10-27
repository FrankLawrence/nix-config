{ ... }:
{
  # Runs syncthing as a launchd agent (systemd user unit on Linux) with the
  # existing config dir, so the device ID stays the same
  services.syncthing = {
    enable = true;
    settings = import ../../modules/shared/syncthing.nix;
  };
}
