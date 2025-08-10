{ config, pkgs, ... }:

{
  # NFS mounts
  boot.initrd =
  {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  fileSystems."/mnt/nfs" = {
    device = "192.168.178.40:/volume1/nfs/";
    fsType = "nfs";
    options = [ "x-systemd automount" "noauto" ];
  };
  fileSystems."/mnt/photo" = {
    device = "192.168.178.40:/volume1/photo/";
    fsType = "nfs";
    options = [ "x-systemd automount" "noauto" ];
  };

}
