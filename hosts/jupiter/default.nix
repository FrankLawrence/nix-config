{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "wol" ];

  networking = {
    hostName = "jupiter";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [ "1.1.1.1" "192.168.178.158" ]; # adguard
    search = [ "wurt.net" ];
    firewall.allowedTCPPorts = [ 
      22   # sshd
      8080 # open-webui
    ];
    interfaces.wlp7s0.wakeOnLan = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    fahclient
    niri
    xwayland-satellite
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.copyparty.overlays.default
  ];

  services.pcscd.enable = true;
  
  services.syncthing = {
    enable = true;
    group = "users";
    user = "frank";
    dataDir = "/home/frank/";
    configDir = "/home/frank/.config/syncthing/";
    guiAddress = "127.0.0.1:8384";
    settings = {
      devices = {
        terra = {
          name = "macbook";
          id = "QJXO57G-AJVI2DV-T3L4VTI-CTSKCVP-2NU5K3D-DZ5VEKY-ZPOPV5O-TU4YTAM";
        };
        centauri = {
          name = "centauri";
          id = "CKT27MM-CB52JEP-ZWXWWCT-N2K4IRE-PWJRLNT-D4EBMZE-ZUBKI3B-SDXXPQN";
        };
      };
      folders = {
        "nb" = {
          path = "~/.nb/";
          devices = [ "terra" ];
          # versioning = {
          #   type = "staggered";
          #   params = {
          #     cleanInterval = "3600";
          #     maxAge = "15552000"; # 180 days in seconds
          #   };
          # };
        };
      };
      folders = {
        "default" = {
          path = "~/Sync/";
          devices = [ "terra" "centauri" ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15552000"; # 180 days in seconds
            };
          };
        };
      };
    };
  };

  services.blueman.enable = true;

  services.tailscale = {
    enable = true;
    port = 41641;
    derper.port = 8010;
    interfaceName = "tailscale0";
    extraSetFlags = [ "--advertise-exit-node" "--accept-routes" ];
    useRoutingFeatures = "both";
  };

  # wireshark permissions
  services.udev = {
    extraRules = ''
      SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
    '';
  };

  services.flatpak.enable = true;

  users.extraGroups.vboxusers.members = [ "frank" ];

  age.identityPaths = [ "/home/frank/.ssh/agenix" ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024;
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
