let
  nas = "192.168.178.40";
  nfsOptions = [
    "x-systemd.automount"
    "noauto"
    "_netdev"
    "nfsvers=4.0"
    "nosuid"
    "nodev"
    "noexec"
  ];
in
{
  # NFS mounts
  boot = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  fileSystems."/mnt/photo" = {
    device = "${nas}:/volume1/photo";
    fsType = "nfs";
    # Nothing on centauri writes photos; immich only reads them as an external library
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
      "navidrome"
      "slskd"
    ];
  };
  users.groups.nas-media-rw = {
    gid = 65537;
    members = [
      "lidarr"
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
  systemd.tmpfiles.rules = [
    "d /srv/library 2775 root library -"
    "d /srv/library/manga 2775 root library -"
    "d /srv/library/books 2775 root library -"
  ];
}
