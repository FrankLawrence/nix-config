{ config, pkgs, input, ... }:
{
  users.users.frank = {
    isNormalUser = true;
    description = "frank";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLxYWRdvzd01GebtUTxUgLO6F5z/ricceiy6Gs6IU/H pinkfloyd@terra.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKc+QGEfGE7T+NcAN8EkDDx3bg5z2ucrecMwbkBve2RY frank@jupiter"
    ];
  };

  users.users.nixosvmtest.isSystemUser = true;
  users.users.nixosvmtest.initialPassword = "test";

  users.groups.nixosvmtest = {};
  users.users.nixosvmtest.group = "nixosvmtest";
}
