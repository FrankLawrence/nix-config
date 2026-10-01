{ config, pkgs, inputs, ... }:

{
  imports = [
    ../default.nix
    ../programs/terminal/kitty.nix
    ../programs/editors/zed.nix
    ../programs/tools/omniwm.nix
  ];

  home.username = "frank";
  home.homeDirectory = "/Users/frank";
  home.packages = with pkgs; [
    # shottr
    alacritty
    bat
    container
    drawio
    dust
    eza
    fastfetch
    fd
    feishin
    fira-code
    fzf
    ghidra
    gnupg
    iina
    jujutsu
    keepassxc
    lazygit
    nb
    neovim
    nh
    obsidian
    omniwm
    qbittorrent
    raycast
    ripgrep
    signal-cli
    spotify
    starship
    thunderbird
    tldr
    wireshark
    yazi
    yt-dlp
    zoxide
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  news.display = "silent";
}
