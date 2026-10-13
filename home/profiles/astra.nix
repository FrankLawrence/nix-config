{ config, pkgs, inputs, ... }:

{
  imports = [
    ../default.nix
    ../programs/terminal/fetch.nix
    ../programs/terminal/kitty.nix
    ../programs/editors/zed.nix
    # ../programs/tools/omniwm.nix
  ];

  home.username = "frank";
  home.homeDirectory = "/Users/frank";
  home.packages = with pkgs; [
    alacritty
    bat
    devenv
    docker
    docker-compose
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
    halloy
    iina
    jujutsu
    karabiner-elements
    keepassxc
    lazygit
    lima-full
    nb
    neovim
    nh
    nixd
    nixfmt
    obsidian
    qbittorrent
    raycast
    ripgrep
    shottr
    signal-cli
    skimpdf
    spotify
    starship
    syncthing-macos
    thunderbird
    tldr
    typst
    whatcable
    wireshark
    yazi
    yt-dlp
    zoxide
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  news.display = "silent";
}
