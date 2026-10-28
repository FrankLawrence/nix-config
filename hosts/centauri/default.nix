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
      80 # caddy
      443 # caddy
    ];
  };

  services = {
    # Infrastructure
    pocket-id.enable  = true;
    forgejo.enable    = true;
    caddy.enable      = true;
    immich.enable     = true;
    syncthing.enable  = true;
    postgresql.enable = true;
    lldap.enable      = true;

    # Media
    navidrome.enable       = true;
    kavita.enable          = true;
    komga.enable           = false;
    audiobookshelf.enable  = false;
    music-assistant.enable = false;
    calibre-web.enable     = false;
    lidarr.enable          = true;
    qbittorrent.enable     = true;
    jellyfin.enable        = true;
    suwayomi-server.enable = true;

    # Productivity
    glance.enable    = true;
    paperless.enable = true;
    vikunja.enable   = false;
    actual.enable    = false;
    karakeep.enable  = false;
    mealie.enable    = true;
    freshrss.enable  = true;
    bentopdf.enable  = true;

    # Utility
    adguardhome.enable    = true;
    dawarich.enable       = true;
    home-assistant.enable = true;

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
