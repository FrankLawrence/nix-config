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

      2000 # navidrome
      #2010 # kavita
      #2020 # komga

      3000 # glance
      3010 # stirling-pdf
      3020 # paperless
      3030 # vikunja
      #3040 # actual
      3050 # karakeep
      3060 # mealie
      3070 # freshrss
      3080 # bento

      4000 # adguard
      4010 # dawarich

      5000 # auth
      5010 # pocket-id
      #5020 # forgejo
      #5030 # immich
      #5040 # syncthing
      #22000 # synchting TCP and UDP sync traffic
      #21027 # syncthing UDP discovery
      5050 # lldap
      5060 # pgadmin
      5070 # grafana
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
    lldap.enable        = true;
    pgadmin.enable      = true;

    # Media
    navidrome.enable    = true;
    kavita.enable       = false;
    komga.enable        = false;

    # Productivity
    glance.enable       = true;
    stirling-pdf.enable = false;
    paperless.enable    = true;
    vikunja.enable      = true;
    actual.enable       = false;
    karakeep.enable     = true;
    mealie.enable       = true;
    freshrss.enable     = true;
    bentopdf.enable     = true;

    # Utility
    adguardhome.enable  = true;
    dawarich.enable     = true;

    # -- System Services --
    qemuGuest.enable          = true;
    cloud-init.network.enable = true;
    tailscale.enable          = true;
  };

  system.stateVersion = "24.11";
}
