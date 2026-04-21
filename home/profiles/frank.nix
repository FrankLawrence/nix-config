{ config, pkgs, inputs, ... }:

{
  imports = [
    ../default.nix
  ];

  home.username = "frank";
  home.homeDirectory = "/home/frank";
  home.packages = with pkgs; [
    blender-hip
    burpsuite
    caligula
    cmatrix
    cryfs
    darktable
    davinci-resolve
    delve
    digikam
    discord
    drawio
    duf
    dust
    emacs
    fahclient
    feishin
    fira-code
    foliate
    fselect
    gaphor
    gdb
    ghidra
    gimp
    glow
    gnupg
    gpg-tui
    grim
    heroic
    hieroglyphic
    hl-log-viewer
    hledger
    hledger-fmt
    hledger-ui
    hledger-utils
    hyprshot
    inetutils
    inkscape
    jujutsu
    keepassxc
    lazyjournal
    lnav
    localsend
    lolcat
    lua-language-server
    mindustry
    navi
    nb
    neofetch
    nh
    obsidian
    ollama-rocm
    pinentry-curses
    postman
    python3
    qbittorrent
    qemu
    signal-cli
    signal-desktop
    spotify
    starship
    superfile
    thunderbird
    tor
    tor-browser
    typst
    vlc
    vscodium
    wireshark
    yt-dlp
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  news.display = "silent";
}
