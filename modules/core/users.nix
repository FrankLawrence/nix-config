{ lib, ... }:
{
  users.users.frank = {
    isNormalUser = true;
    description = "frank";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLxYWRdvzd01GebtUTxUgLO6F5z/ricceiy6Gs6IU/H pinkfloyd@terra"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKc+QGEfGE7T+NcAN8EkDDx3bg5z2ucrecMwbkBve2RY frank@jupiter"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHF74YUVsg4hy0y4/MhvHKHjfoJUgJsHHar8UD/fJCD frank@astra"
    ];
    initialHashedPassword = lib.mkDefault "$y$j9T$R2u8Wz6/Rr5FkoSli.AlG/$xfwnN4NElrdIA1UaX68NbovbV0gox5eGE9KA9MjcdN5";
  };
}
