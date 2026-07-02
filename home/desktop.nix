{ config, pkgs, ... }:
{
  imports = [
    ./programs/browsers/librewolf.nix
    ./programs/desktop/desktop.nix
    ./programs/editors/zed.nix
    ./programs/terminal/kitty.nix
    ./programs/tools/rofi.nix
    ./services/flameshot.nix
  ];
}
