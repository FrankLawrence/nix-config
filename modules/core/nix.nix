{ config, pkgs, input, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
