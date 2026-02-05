{ pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  environment.systemPackages = with pkgs; [
    frp
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
  swapDevices = [
  {
    device = "/dev/disk/by-label/swap";
  }
  ];

  systemd.network.enable = true;
  # systemd.network.networks."30-wan" = {
  #   matchConfig.Name = "enp1s0";
  #   networkConfig.DHCP = "ipv4";
  #   address = [
  #     "2a01:4f9:c012:d8e::1/64"
  #   ];
  #   routes = [
  #   { Gateway = "fe80::1"; }
  #   ];
  # };

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  # boot.loader.grub.device = "/dev/sda";

  programs.ssh.startAgent = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 6000 7000 ];

  system.stateVersion = "24.11";
}
