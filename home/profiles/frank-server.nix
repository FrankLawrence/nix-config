{ config, pkgs, inputs, ... }:

{
  imports = [
    ../default.nix
  ];

  home.username = "frank";
  home.homeDirectory = "/home/frank";

  home.packages = with pkgs; [
    duf
    dust
    glow
    inetutils
    lnav
    nh
    python3
    ripgrep
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  news.display = "silent";
}
