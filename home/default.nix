{ config, pkgs, input, ... }:
{
 
  imports = [
    ./programs/browsers/librewolf.nix
    ./programs/terminal/shells/bash.nix
    ./programs/terminal/kitty.nix
    ./programs/terminal/tmux.nix
    ./programs/terminal/btop.nix
    ./programs/tools/git.nix
  ];
}
