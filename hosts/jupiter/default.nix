# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "wol" ];

  networking = {
    hostName = "jupiter";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [ "1.1.1.1" "192.168.178.158" ]; # adguard
    search = [ "wurt.net" ];
    firewall.allowedTCPPorts = [ 
      22   # sshd
      8080 # open-webui
    ];
    interfaces.wlp7s0.wakeOnLan = {
      enable = true;
    };
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

  # Enable the wayland windowing system
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
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
        Experimental = true;
	FastConnectable = true;
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
    extraGroups = [ "networkmanager" "wheel" "docker" "shared-media" ];
    packages = with pkgs; [
      blender-hip
      btop
      cmatrix
      # davinci-resolve
      digikam
      dust
      emacs
      fira-code
      foliate
      ghidra
      gimp
      glow
      hyprshot
      inkscape
      libreoffice
      librewolf
      localsend
      mindustry
      obsidian
      pinentry
      razergenie
      signal-cli
      signal-desktop
      spotify
      tor-browser
      thunderbird
      vlc
      vscodium
      winetricks
      wineWowPackages.stable
      wireshark
      yt-dlp
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "python2"
    ];
  nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    clinfo
    eza
    fd
    ffmpeg
    fish
    fselect
    fzf
    gcc
    gdb
    gh
    git
    htop
    keepassxc
    lazygit
    nb
    neofetch
    neovim
    tldr
    tor
    typst
    ripgrep
    yazi
    zoxide
    inputs.agenix.packages."${system}".default
  ];

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
      daemon.settings.data-root = "/var/lib/docker";
    };
    virtualbox.host = {
      enable = true;
      enableKvm = true;
      addNetworkInterface = false;
    };
  };

  age.identityPaths = [ "/home/frank/.ssh/id_ed25519" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.pcscd.enable = true;
  
  services.syncthing = {
    enable = true;
    group = "users";
    user = "frank";
    dataDir = "/home/frank/";
    configDir = "/home/frank/.config/syncthing/";
    guiAddress = "127.0.0.1:8384";
    settings = {
      devices = {
        terra = {
          name = "macbook";
          id = "QJXO57G-AJVI2DV-T3L4VTI-CTSKCVP-2NU5K3D-DZ5VEKY-ZPOPV5O-TU4YTAM";
        };
        centauri = {
          name = "centauri";
          id = "CKT27MM-CB52JEP-ZWXWWCT-N2K4IRE-PWJRLNT-D4EBMZE-ZUBKI3B-SDXXPQN";
        };
      };
      folders = {
        "nb" = {
          path = "~/.nb/";
          devices = [ "terra" ];
          # versioning = {
          #   type = "staggered";
          #   params = {
          #     cleanInterval = "3600";
          #     maxAge = "15552000"; # 180 days in seconds
          #   };
          # };
        };
      };
      folders = {
        "default" = {
          path = "~/Sync/";
          devices = [ "terra" "centauri" ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15552000"; # 180 days in seconds
            };
          };
        };
      };
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.foldingathome.enable = true;

  services.blueman.enable = true;

  services.tailscale = {
    enable = true;
    port = 41641;
    derper.port = 8010;
    interfaceName = "tailscale0";
    extraSetFlags = [ "--advertise-exit-node" "--accept-routes" ];
    useRoutingFeatures = "both";
  };

  # wireshark permissions
  services.udev = {
    extraRules = ''
      SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
    '';
  };

  users.extraGroups.vboxusers.members = [ "frank" ];

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
