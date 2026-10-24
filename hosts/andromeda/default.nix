{ pkgs, ... }:
{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    frp
  ];

  console.keyMap = "us";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/sda";
  };

  programs.ssh.startAgent = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  networking = {
    hostName = "andromeda";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      22
      6000
      7000
    ];
  };

  system.stateVersion = "24.11";
}
