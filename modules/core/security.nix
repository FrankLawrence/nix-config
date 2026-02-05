{ config, pkgs, input, lib, ... }:
{
  # Set ssh key to decrypt for agenix
  age.identityPaths = [ "/home/frank/.ssh/agenix" ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  networking.firewall.enable = lib.mkForce true;
}
