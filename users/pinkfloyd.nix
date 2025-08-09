{ config, pkgs, ... }:


{
  users.groups.nfsmusic = {
    members = [ "pinkfloyd" ];
  };

  users.users.pinkfloyd = {
    isNormalUser = true;
    description = "pinkfloyd";
    extraGroups = [ "networkmanager" "wheel" "nfsmusic" ];
    packages = with pkgs; [
      firefox
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLxYWRdvzd01GebtUTxUgLO6F5z/ricceiy6Gs6IU/H pinkfloyd@terra.local"
    ];
  };

}
