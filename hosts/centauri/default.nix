{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking = {
    hostName = "centauri";
    networkmanager.enable = true;

    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.178.171";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.178.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall.allowedTCPPorts = [
      22   # ssh
      80   # reverse-proxy
      443  # reverse-proxy
      1411 # pocket-id
      # 2222 # forgejo ssh
      # 2283 # immich
      # 3000 # dawarich
      # 3004 # sparkyfitness
      # 3474 # mazanoke
      # 5000 # kavita
      5001 # navidrome
      8081 # stirling-pdf
      # 8082 # komga
      # 8083 # omni-tools
      8084 # glance
      # 8338 # metadata-remote
      # 8384 # syncthing webUI
      # 22000 # synchting TCP and UDP sync traffic
      # 21027 # syncthing UDP discovery
      # 9000 # mealie
      # 9222 # karakeep
    ];
  };

  services = {
    # Productivity
    glance.enable       = true;
    stirling-pdf.enable = true;
    actual.enable       = false;
    vikunja.enable      = false;
    karakeep.enable     = false;
    paperless.enable    = false;
    mealie.enable       = false;

    # Media
    navidrome.enable    = true;
    kavita.enable       = false;
    komga.enable        = false;

    # Infrastructure
    pocket-id.enable    = true;
    caddy.enable        = true;
    postgresql.enable   = true;
    syncthing.enable    = false;
    forgejo.enable      = false;
    immich.enable       = false;

    # Utility
    dawarich.enable     = false;

    # -- System Services --
    qemuGuest.enable          = true;
    cloud-init.network.enable = true;
    tailscale.enable          = true;
  };

  system.stateVersion = "24.11";
}
