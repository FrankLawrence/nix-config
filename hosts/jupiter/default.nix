# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "jupiter";
    networkmanager.enable = true;
    nameservers = [ "192.168.178.158" ]; # adguard
    defaultGateway = "192.168.178.1";  # Your router IP
    search = [ "wurt.net" ];
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable HIP libraries for GPU rendering
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.frank = {
    isNormalUser = true;
    description = "Frank";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      blender
      btop
      burpsuite
      cmatrix
      digikam
      dmenu
      dust
      emacs
      ghidra
      gimp
      glow
      i3
      inkscape
      libreoffice
      librewolf
      obsidian
      signal-cli
      signal-desktop
      tor-browser
      thunderbird
      vlc
      vscodium
      wireshark
      yt-dlp
    ];
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
      ExtensionSettings = {
        "jid1-ZAdIEUB7XOzOJw@jetpack" = { # DuckDuckGo
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = { # uBlock Origin
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "keepassxc-browser@keepassxc.org" = { # KeePassXC
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          installation_mode = "force_installed";
        };
        "snowflake@torproject.org" = { # Snowflake
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/snowflake/latest.xpi";
          installation_mode = "force_installed";
        };
        "vimium@vimium.com" = { # Vimium
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium/latest.xpi";
          installation_mode = "force_installed";
        };
        "darkreader@darkreader.org" = { # Dark Reader
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";

  programs.bash.shellAliases = {
    ".." = "z ..";
    "..." = "z ../..";
    "...." = "z ../../..";
    ".3" = "z ../../..";
    ".4" = "z ../../../..";
    cp = "cp -i";
    rm = "rm -i";
    mv = "mv -i";
    ls = "eza -al --color=always --group-directories-first";
    la = "eza -a --color=always --group-directories-first";
    ll = "eza -l --color=always --group-directories-first";
    lt = "eza -aT --color=always --group-directories-first";
    "l." = "eza -a | egrep '^\\.'";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    clinfo
    eza
    ffmpeg
    fd
    fish
    fselect
    fzf
    gcc
    gdb
    gh
    git
    htop
    keepassxc
    kitty
    lazygit
    nb
    neofetch
    neovim
    tldr
    tor
    typst
    tmux
    yazi
    zoxide
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List services that you want to enable:

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

