{ pkgs, ... }:

# Reference: https://www.joshuamlee.com/nixos-proxmox-vm-images/
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  networking = {
    hostName = "centauri";
    networkmanager.enable = true;

    interfaces.enp1s0.ipv4.addresses = [
      {
        address = "192.168.178.128";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.178.1";
    nameservers = [ "1.1.1.1" ];
    firewall.allowedTCPPorts = [
      22 # ssh
      # 80 # caddy
      # 443 # caddy

      # 3020 # paperless
      # 3030 # vikunja
      # 3050 # karakeep
      3060 # mealie
      # 3070 # freshrss
      # 3080 # bento

      # 4010 # dawarich

      # 5000 # auth
      # 5010 # pocket-id
      # 5020 # forgejo
      # 5040 # syncthing
      # 22000 # synchting TCP and UDP sync traffic
      # 21027 # syncthing UDP discovery
      # 5050 # lldap
    ];
  };

  services = {
    # Infrastructure
    pocket-id.enable = false;
    forgejo.enable = false;
    caddy.enable = false;
    immich.enable = false;
    syncthing.enable = false;
    postgresql.enable = true;
    lldap.enable = false;
    pgadmin.enable = false;

    # Media
    navidrome.enable = true;
    kavita.enable = true;
    komga.enable = false;
    audiobookshelf.enable = false;
    music-assistant.enable = false;
    calibre-web.enable = false;
    lidarr.enable = false;
    slskd.enable = false;
    qbittorrent.enable = false;
    jellyfin.enable = false;
    suwayomi-server.enable = true;

    # Productivity
    glance.enable = true;
    paperless.enable = false;
    vikunja.enable = false;
    actual.enable = false;
    karakeep.enable = false;
    mealie.enable = true;
    freshrss.enable = false;
    # bentopdf.enable     = true;

    # Utility
    adguardhome.enable = true;
    dawarich.enable = false;
    home-assistant.enable = false;

    # -- System Services --
    tailscale.enable = true;
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
