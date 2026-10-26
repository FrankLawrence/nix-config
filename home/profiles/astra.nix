{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  # waterfox-flake is broken on aarch64-darwin: its hash is hex with an "sha256-"
  # prefix (not valid SRI), the DMG is APFS (undmg can't unpack it), and the app
  # now ships Contents/MacOS/waterfox itself, so the flake's symlinks collide.
  waterfox = pkgs.wrapFirefox (inputs.waterfox.packages.${system}.waterfox-unwrapped.overrideAttrs
    (old: {
      src = pkgs.fetchurl {
        inherit (old.src) url;
        hash = "sha256-fq5PSCk3sjv6gyheYcLZ5Q1NjP1mLfqm6oMHKPw0Riw=";
      };
      nativeBuildInputs = [ pkgs._7zz ];
      unpackPhase = ''
        runHook preUnpack
        7zz x -snld "$src"
        runHook postUnpack
      '';
      installPhase =
        builtins.replaceStrings
          [
            ''ln -s waterfox "$out/Applications/Waterfox.app/Contents/MacOS/waterfox"''
            ''ln -s "$out/bin/waterfox" "$out/bin/waterfox"''
          ]
          [
            ""
            ""
          ]
          old.installPhase;
    })
  ) { };
in
{
  imports = [
    ../default.nix
    ../programs/terminal/fetch.nix
    ../programs/terminal/kitty.nix
    ../programs/editors/neovim.nix
    ../programs/editors/zed.nix
  ];

  home.username = "frank";
  home.homeDirectory = "/Users/frank";
  home.packages = with pkgs; [
    waterfox
    inputs.helium.packages.${system}.helium
    alacritty
    bat
    colima
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
    obsidian
    qbittorrent
    raycast
    readest
    ripgrep
    shottr
    signal-cli
    skimpdf
    spotify
    starship
    syncthing-macos
    thunderbird
    tldr
    whatcable
    wireshark
    yazi
    yt-dlp
    zoxide

    # langauge support
    nixd
    nixfmt
    nodejs_26
    pyright
    typst
    pwntools
    gef
    nmap
    netcat
    wget
    exiftool
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  news.display = "silent";
}
