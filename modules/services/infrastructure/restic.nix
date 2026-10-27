{ config, lib, pkgs, ... }:
let
  # Services with SQLite/file state that should not change while restic reads it.
  # Units that don't exist or aren't running are skipped.
  stopDuringBackup = [
    "audiobookshelf"
    "immich-server"
    "immich-machine-learning"
    "jellyfin"
    "kavita"
    "komga"
    "lidarr"
    "navidrome"
    "qbittorrent"
    "suwayomi-server"
  ];

  stoppedFile = "/run/restic-stopped-units";

  stopServices = pkgs.writeShellScript "restic-stop-services" ''
    : > ${stoppedFile}
    for unit in ${lib.concatStringsSep " " stopDuringBackup}; do
      if ${pkgs.systemd}/bin/systemctl is-active --quiet "$unit"; then
        ${pkgs.systemd}/bin/systemctl stop "$unit"
        echo "$unit" >> ${stoppedFile}
      fi
    done
  '';

  startServices = pkgs.writeShellScript "restic-start-services" ''
    [ -f ${stoppedFile} ] || exit 0
    while read -r unit; do
      ${pkgs.systemd}/bin/systemctl start "$unit" || true
    done < ${stoppedFile}
    rm -f ${stoppedFile}
  '';
in
{
  age.secrets.restic = {
    file = ../../../secrets/restic.age;
    owner = "restic";
    group = "restic";
  };

  # Root on the NAS is squashed to guest, so restic runs as its own user and
  # writes to /mnt/backup through the nas-backup group.
  users.users.restic = {
    isSystemUser = true;
    group = "restic";
  };
  users.groups.restic = { };

  # Daily dump of every database (immich, suwayomi, ...) for restic to pick up
  services.postgresqlBackup = lib.mkIf config.services.postgresql.enable {
    enable = true;
    backupAll = true;
    location = "/var/backup/postgresql";
    compression = "zstd";
    # Before restic, and both well before the NAS powers off at 02:00
    startAt = "*-*-* 23:15:00";
  };

  services.restic.backups.nas = {
    user = "restic";
    repository = "/mnt/backup/centauri";
    passwordFile = config.age.secrets.restic.path;
    initialize = true;

    paths = [
      "/var/lib"
      "/srv"
      "/var/backup/postgresql"
    ];
    exclude = [
      # Live database files; restored from the dump instead
      "/var/lib/postgresql"
      # Container images and other rebuildable data
      "/var/lib/containers"
      "/var/lib/docker"
      "/var/lib/systemd/coredump"
      # Immich derivatives, regenerated from the originals
      "/var/lib/immich/thumbs"
      "/var/lib/immich/encoded-video"
    ];

    timerConfig = {
      OnCalendar = "*-*-* 23:30:00";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };

  systemd.services.restic-backups-nas = {
    after = [ "postgresqlBackup.service" ];
    unitConfig.RequiresMountsFor = [ "/mnt/backup" ];
    serviceConfig = {
      # Read all local state without being root
      AmbientCapabilities = [ "CAP_DAC_READ_SEARCH" ];
      CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
      # "+" runs these as root, outside User=restic
      ExecStartPre = lib.mkBefore [ "+${stopServices}" ];
      ExecStopPost = lib.mkAfter [ "+${startServices}" ];
    };
  };
}

