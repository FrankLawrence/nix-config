{ config, pkgs, input, ... }:
{
 
  imports = [
    ./programs/browsers/librewolf.nix
    ./programs/terminal/shells/bash.nix
    ./programs/terminal/shells/fish
    ./programs/terminal/kitty.nix
    ./programs/terminal/yazi.nix
    ./programs/terminal/tmux.nix
    ./programs/terminal/btop.nix
    ./programs/tools/git.nix
    ./programs/tools/gh.nix
  ];
}
