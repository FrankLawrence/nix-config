{ config, pkgs, inputs, ... }:

{
  imports = [
    ./programs/tmux.nix
    ./programs/hyprland.nix
  ];
  home.username = "frank";
  home.homeDirectory = "/home/frank";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # davinci-resolve
    blender-hip
    btop
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
    foliate
    ghidra
    gimp
    glow
    gnupg
    go
    gpg-tui
    hyprshot
    inetutils
    inkscape
    libreoffice
    librewolf
    lima
    localsend
    lolcat
    mindustry
    navi
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
    steam
    starship
    thunderbird
    tor-browser
    vlc
    vscodium
    wireshark
    yt-dlp
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
  };

  services.ollama = {
    enable = true;
    port = 11434;
    # loadModels = [ "phi4:14b" ];
    acceleration = "rocm";
    # rocmOverrideGfx = "10.3.6";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };
    shellIntegration.enableBashIntegration = true;
    enableGitIntegration = true;
    settings = {
      window_padding_width = 10;
      hide_window_decorations = true;
      background_opacity = 1.0;
      background_blue = 0.7;
      editor = "nvim";
      font_size = 14.0;
    };
    themeFile = "rose-pine";
  };

  programs.freetube.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
