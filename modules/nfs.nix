{ config, pkgs, ... }:

{
  # NFS mounts
  boot.initrd =
  {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" 1;
  };

  fileSystems."/mnt/music" = {
    device = "192.168.178.40:/volume1/Music/";
    fsType = "nfs";
    options = [ "x-systemd automount" "noauto" ];
  };

  # systemd.tmpfiles.rules = [
  #   "d /mnt/photo 0770 root nfsphoto -"
  #   "d /mnt/immich 0770 root nfsimmich -"
  #   "d /mnt/homes 0770 root nfshomes -"
  # ];
}
