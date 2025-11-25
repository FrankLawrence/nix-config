{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
  ];

  home.username = "frank";
  home.homeDirectory = "/home/frank";
  home.packages = with pkgs; [
    davinci-resolve
    blender-hip
    burpsuite
    cmatrix
    cryfs
    darktable
    digikam
    discord
    dust
    emacs
    fahclient
    feishin
    fira-code
    foliate
    freetube
    fselect
    gdb
    ghidra
    gimp
    glow
    gnupg
    gpg-tui
    hyprshot
    inetutils
    inkscape
    keepassxc
    localsend
    lolcat
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
    steam
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
}
