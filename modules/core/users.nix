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
    initialHashedPassword = "$y$j9T$R2u8Wz6/Rr5FkoSli.AlG/$xfwnN4NElrdIA1UaX68NbovbV0gox5eGE9KA9MjcdN5";
  };
}
