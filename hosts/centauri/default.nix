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

      # 22000 # synchting TCP and UDP sync traffic
      # 21027 # syncthing UDP discovery

      2000 # navidrome

      3000 # glance
      3010 # stirling-pdf
      3030 # vikunja

      4000 # adguard

      5000 # auth
      5010 # pocket-id
    ];
  };

  services = {
    # Infrastructure
    pocket-id.enable    = true;
    forgejo.enable      = false;
    caddy.enable        = true;
    immich.enable       = false;
    syncthing.enable    = false;
    postgresql.enable   = true;

    # Media
    navidrome.enable    = true;
    kavita.enable       = false;
    komga.enable        = false;

    # Productivity
    glance.enable       = true;
    stirling-pdf.enable = true;
    paperless.enable    = false;
    vikunja.enable      = true;
    actual.enable       = false;
    karakeep.enable     = false;
    mealie.enable       = false;

    # Utility
    adguardhome.enable  = true;
    dawarich.enable     = false;

    # -- System Services --
    qemuGuest.enable          = true;
    cloud-init.network.enable = true;
    tailscale.enable          = true;
  };

  system.stateVersion = "24.11";
}
