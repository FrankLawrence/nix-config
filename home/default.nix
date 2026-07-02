{ config, pkgs, input, ... }:
{
  imports = [
    ./programs/terminal/btop.nix
    ./programs/terminal/nix-direnv.nix
    ./programs/terminal/nvim.nix
    ./programs/terminal/shells/bash.nix
    ./programs/terminal/shells/fish
    ./programs/terminal/tmux.nix
    ./programs/terminal/yazi.nix
    ./programs/tools/gh.nix
    ./programs/tools/git.nix
  ];
}
