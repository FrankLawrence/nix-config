{ pkgs, ... }:
let
  nas = "192.168.178.40";
  nasMac = "00:11:32:aa:fb:13";
  mounts = [
    "/mnt/photo"
    "/mnt/video"
    "/mnt/music"
    "/mnt/backup"
  ];
  nfsOptions = [
    "x-systemd.automount"
    "noauto"
    "_netdev"
    # Unmount when unused, and give up on a mount attempt while the NAS is off
    # instead of blocking the process that touched the path
    "x-systemd.idle-timeout=10min"
    "x-systemd.mount-timeout=30s"
    "nfsvers=4.0"
    "nosuid"
    "nodev"
    "noexec"
  ];
in
{
  # The NAS powers off 02:00-10:00. A hard NFS mount that is still mounted then
  # blocks everything that touches it until the NAS is back, so detach the mounts
  # just before. The automounts stay armed: the first access after 10:00 mounts
  # again, and accesses while the NAS is off fail after mount-timeout.
  # Lazy, because jellyfin/navidrome keep inotify watches that make a plain umount busy.
  systemd.services.nas-unmount = {
    description = "Detach NAS mounts before the NAS powers off";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = map (m: "-${pkgs.util-linux}/bin/umount --lazy ${m}") mounts;
    };
  };
  systemd.timers.nas-unmount = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "*-*-* 01:55:00";
  };

  systemd.services.nas-wake = {
    description = "Wake the NAS with a magic packet";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.wakeonlan}/bin/wakeonlan -i 192.168.178.255 ${nasMac}";
    };
  };
  systemd.timers.nas-wake = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 10:00:00";
      Persistent = true;
    };
  };

  # NFS mounts
  boot = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  fileSystems."/mnt/photo" = {
    device = "${nas}:/volume1/photo";
    fsType = "nfs";
    options = nfsOptions ++ [ "ro" ];
  };
  fileSystems."/mnt/video" = {
    device = "${nas}:/volume1/video";
    fsType = "nfs";
    options = nfsOptions;
  };
  fileSystems."/mnt/music" = {
    device = "${nas}:/volume1/music";
    fsType = "nfs";
    options = nfsOptions;
  };
  fileSystems."/mnt/backup" = {
    device = "${nas}:/volume1/backup";
    fsType = "nfs";
    options = nfsOptions;
  };

  # GIDs must match the groups created in DSM (see /etc/group on the NAS)
  users.groups.nas-media-ro = {
    gid = 65536;
    members = [
      "frank"
      "immich"
      "jellyfin"
      "slskd"
    ];
  };
  users.groups.nas-media-rw = {
    gid = 65537;
    members = [
      "qbittorrent"
    ];
  };
  users.groups.nas-backup = {
    gid = 65538;
    members = [ "restic" ];
  };

  # frank can write to the media shares only through sudo:
  #   sudo -g nas-media-rw cp -r album /mnt/music/
  security.sudo.extraRules = [
    {
      users = [ "frank" ];
      runAs = "frank:nas-media-rw";
      commands = [ "ALL" ];
    }
  ];

  # Local library for komga/kavita/suwayomi (backed up to the NAS by restic)
  users.groups.library.members = [
    "frank"
    "kavita"
    "komga"
    "suwayomi"
  ];
  users.groups.music.members = [
    "frank"
    "navidrome"
    "lidarr"
    "slskd"
    "music-assistant"
  ];
  systemd.tmpfiles.rules = [
    "d /srv/library 2775 root library -"
    "d /srv/library/manga 2775 root library -"
    "d /srv/library/books 2775 root library -"
    "d /srv/music 2775 root music -"
  ];
}
