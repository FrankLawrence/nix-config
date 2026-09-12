{ config, pkgs, inputs, ... }:

{
  imports = [
    ../default.nix
    ../desktop.nix
  ];

  home.username = "frank";
  home.homeDirectory = "/home/frank";
  home.packages = with pkgs; [
    audacity
    aria2
    anytype
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
    picard
    pinentry-curses
    postman
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
    vlc
    vscodium
    wireshark
    yt-dlp
    zed-editor
    halloy
    ida-free

    # MacOS
    # aerospace
    # amethyst
    # anki
    # blackhole
    # colima
    # cryptomator
    # czkawka
    # element-desktop
    # freetube
    # ghostty
    # hexfiend
    # hidden-bar
    # iina
    # karabiner-elements
    # keepassxc
    # lazydocker
    # lima
    # localsend
    # logseq
    # magic-wormhole
    # makemkv
    # monero-gui
    # nethack
    # nextcloud-client
    # notesnook
    # notion
    # picard
    # pureref
    # raycast
    # readest
    # rectangle
    # seanime
    # shortcat
    # shottr
    # skimpdf
    # spacedrive
    # spotube
    # syncthing-macos
    # tailscale
    # tailscale-gui
    # the-unarchiver
    # zed-editor
    # zotero

    # CLI
    # superfile
  ];

  # BREW
  # Vorssaint
  # capsomnia
  # macs-fan-control
  # clop
  # tinkertool
  # landrop
  # appcleaner
  # pearcleaner
  # suspicous-package
  # yubico-authenticator
  # creality-print
  # affinity-photo
  # detext
  # cryptomator
  # superduper
  # zen-editor
  # hidden-bar

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  news.display = "silent";
}
