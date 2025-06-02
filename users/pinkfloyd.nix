{ config, pkgs, ... }:


{
  users.groups.nfsimmich = {
    members = [ "pinkfloyd" ];
  };
  users.groups.nfsphoto = {
    members = [ "pinkfloyd" ];
  };
  users.groups.nfshomes = {
    members = [ "pinkfloyd" ];
  };

  users.users.pinkfloyd = {
    isNormalUser = true;
    description = "pinkfloyd";
    extraGroups = [ "networkmanager" "wheel" "nfsimmich" "nfsphoto" "nfshomes" ];
    packages = with pkgs; [
      firefox
    ];
  };
}
