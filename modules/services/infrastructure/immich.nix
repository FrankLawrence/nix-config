{ config, lib, ... }:

lib.mkIf config.services.immich.enable {
  # age.secrets.immich = {
  #   file = ../../../secrets/immich.age;
  #   owner = "immich";
  #   group = "immich";
  # };

  services.immich = {
    port = 1030;
    openFirewall = true;
    # Phone uploads stay on the local disk and are backed up to the NAS by restic.
    # The NAS photo share is read-only, added in the UI as an external library at /mnt/photo
    mediaLocation = "/var/lib/immich";
    # secretsFile = config.age.secrets.immich.path;

    settings = {
      newVersionCheck.enabled = true;
      server.externalDomain = "https://immich.wurt.net";
    };

    host = "127.0.0.1";
  };

  # Wait for the NAS so the external library is readable
  systemd.services.immich-server = {
    after = [ "remote-fs.target" ];
    wants = [ "remote-fs.target" ];
  };

  custom.glance.monitoredSites = lib.mkIf config.services.immich.enable [
    {
      title = "Immich";
      url = "https://immich.wurt.net";
      check-url = "http://127.0.0.1:2283";
      icon = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/immich.svg";
    }
  ];
}
