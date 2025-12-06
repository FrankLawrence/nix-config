{ config, pkgs, inputs, ...}:
{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
      daemon.settings.data-root = "/var/lib/docker";
    };
    virtualbox.host = {
      enable = true;
      enableKvm = true;
      addNetworkInterface = false;
    };
    vmVariant = {
      virtualisation = {
        memorySize = 8192;
        cores = 4;
      };
    };
  };
}
