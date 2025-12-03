{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking = {
    hostName = "centauri";
    networkmanager.enable = true;

    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.178.100";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.178.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall.allowedTCPPorts = [
      22   # ssh
      80   # reverse-proxy
      443  # reverse-proxy
      1411 # pocket-id
      2283 # immich
      3004 # sparkyfitness
      3474 # mazanoke
      5000 # kavita
      8081 # stirling-pdf
      8082 # komga
      8083 # omni-tools
      8084 # glance
      8338 # metadata-remote
      8384 # syncthing webUI
      22000 # synchting TCP and UDP sync traffic
      21027 # syncthing UDP discovery
      9000 # mealie
      9222 # karakeep
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  system.stateVersion = "24.11";
}
