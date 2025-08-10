# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
	  ../../modules/glance.nix
    ../../modules/navidrome.nix
    ../../modules/nfs.nix
    ../../modules/immich.nix
	  ../../users/pinkfloyd.nix
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
      address = "192.168.178.156";  # Adjust to your network
      prefixLength = 24;
    }];
    defaultGateway = "192.168.178.1";  # Your router IP
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
      # allowedDUPPorts = [ ... ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    neovim bash fzf eza ripgrep bat curl git
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

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  system.stateVersion = "24.11";
}

