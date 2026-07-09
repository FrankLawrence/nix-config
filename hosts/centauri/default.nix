{ config, pkgs, lib, inputs, ... }:

# Reference: https://www.joshuamlee.com/nixos-proxmox-vm-images/
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/qemu-guest.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };
  boot.growPartition = lib.mkDefault true;

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
      80   # caddy
      443  # caddy

      3020 # paperless
      3030 # vikunja
      3050 # karakeep
      3060 # mealie
      3070 # freshrss
      3080 # bento

      4010 # dawarich

      5000 # auth
      5010 # pocket-id
      #5020 # forgejo
      #5040 # syncthing
      #22000 # synchting TCP and UDP sync traffic
      #21027 # syncthing UDP discovery
      5050 # lldap
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
    navidrome.enable       = true;
    kavita.enable          = false;
    komga.enable           = true;
    audiobookshelf.enable  = true;
    music-assistant.enable = false;
    calibre-web.enable     = false;
    lidarr.enable          = true;

    # Productivity
    glance.enable       = true;
    paperless.enable    = true;
    vikunja.enable      = true;
    actual.enable       = false;
    karakeep.enable     = true;
    mealie.enable       = true;
    freshrss.enable     = true;
    # bentopdf.enable     = true;

    # Utility
    adguardhome.enable  = true;
    dawarich.enable     = true;
    home-assistant.enable = true;

    # -- System Services --
    qemuGuest.enable          = true;
    cloud-init.network.enable = true;
    tailscale.enable          = true;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  system.stateVersion = "24.11";
}
