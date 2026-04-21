{ config, pkgs, input, lib, ... }:
{
  # Set ssh key to decrypt for agenix
  age.identityPaths = [ "/home/frank/.ssh/agenix" ];

  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      authorizedKeysInHomedir = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    fail2ban = {
      enable = true;
      maxretry = 3;
    };
  };

  networking.firewall.enable = lib.mkForce true;
}
