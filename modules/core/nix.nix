{ config, pkgs, input, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "frank" ];
}
