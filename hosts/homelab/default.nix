# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/glance.nix
    # ../../modules/immich.nix
    ../../modules/karakeep.nix
    ../../modules/kavita.nix
    ../../modules/komga.nix
    ../../modules/mazanoke.nix
    ../../modules/mealie.nix
    ../../modules/metadata-remote.nix
    ../../modules/navidrome.nix
    ../../modules/nfs.nix
    ../../modules/omni-tools.nix
    ../../modules/pocket-id.nix
    ../../modules/stirling-pdf.nix
    ../../modules/syncthing.nix
    ../../users/pinkfloyd.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking = {
    hostName = "centauri";
    networkmanager.enable = true;

    # Configure static IP for your local network
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.178.156";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.178.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
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
      # allowedDUPPorts = [ ... ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    bash
    bat
    clang
    compose2nix
    curl
    eza
    fzf
    gcc
    git
    gh
    lazygit
    neovim
    ripgrep
    zig
    inputs.agenix.packages."${system}".default
  ];

  programs.bash.shellAliases = {
    ".." = "z ..";
    "..." = "z ../..";
    "...." = "z ../../..";
    ".3" = "z ../../..";
    ".4" = "z ../../../..";
    cp = "cp -i";
    rm = "rm -i";
    mv = "mv -i";
    ls = "eza -al --color=always --group-directories-first";
    la = "eza -a --color=always --group-directories-first";
    ll = "eza -l --color=always --group-directories-first";
    lt = "eza -aT --color=always --group-directories-first";
    "l." = "eza -a | egrep '^\\.'";
  };

  programs.ssh.startAgent = true;

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      pull.rebase = false;
      user = {
        name = "FrankLawrence";
        email = "frankl.am.htg@icloud.com";
      };
      alias = {
        hist = "log --oneline --graph --all";
      };
    };
  };

  # Set ssh key to decrypt for agenix
  age.identityPaths = [ "/home/pinkfloyd/.ssh/id_ed25519" ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}
