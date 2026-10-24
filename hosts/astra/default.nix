{
  pkgs,
  inputs,
  config,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 6;
  system.primaryUser = "frank";

  users.users.frank = {
    name = "frank";
    home = "/Users/frank";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  age.identityPaths = [ "/Users/frank/.ssh/agenix" ];

  age.secrets = {
    wg-astra-private.file = ../../secrets/wg-astra-private.age;
    wg-astra-preshare.file = ../../secrets/wg-astra-preshare.age;
  };

  networking = {
    hostName = "Astra";
    wg-quick.interfaces.wg0 = {
      address = [ "192.168.178.206/24" ];
      dns = [
        "192.168.178.1"
        "fritz.box"
        "1.1.1.1"
      ];
      privateKeyFile = config.age.secrets.wg-astra-private.path;
      # listenPort = 51820;                     # only needed if you accept inbound
      # mtu = 1420;

      peers = [
        {
          publicKey = "dpLkWTsks3cciSD4v3i8j0do+6PxV6+9FdthzliTsRI=";
          presharedKeyFile = config.age.secrets.wg-astra-preshare.path;
          allowedIPs = [
            "192.168.178.0/24"
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "d6hfqdbjfwyjurlm.myfritz.net:52424";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  homebrew = {
    enable = true;
    brews = [
      "mlx-lm"
      "container"
    ];
    casks = [
      "affinity"
      "claude"
      "clop"
      "librewolf"
      "ollama-app"
      "signal"
      "tailscale-app"
      "vorssaint"
    ];
  };

  system = {
    keyboard = {
      enableKeyMapping = false;
      # remapCapsLockToEscape = true;
    };
    defaults = {
      trackpad = {
        TrackpadThreeFingerVertSwipeGesture = 0;
        TrackpadThreeFingerHorizSwipeGesture = 0;
        TrackpadFourFingerVertSwipeGesture = 0;
      };
      finder = {
        ShowPathbar = true;
        NewWindowTarget = "Home";
      };
      dock = {
        showhidden = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.5;
        persistent-apps = [
          {
            app = "/Applications/Librewolf.app";
          }
          {
            app = "/Applications/Signal.app";
          }
          {
            app = "${pkgs.feishin}/Applications/Feishin.app";
          }
          {
            app = "${pkgs.keepassxc}/Applications/KeePassXC.app";
          }
          {
            app = "${pkgs.obsidian}/Applications/Obsidian.app";
          }
          {
            app = "${pkgs.thunderbird}/Applications/Thunderbird.app";
          }
          {
            app = "${pkgs.zed-editor}/Applications/Zed.app";
          }
        ];
      };
      controlcenter = {
        BatteryShowPercentage = true;
      };
    };
  };

  services = {
    jankyborders = {
      enable = false;
      active_color = "#EB6F92";
      blur_radius = 5.0;
      width = 3.0;
    };
    aerospace = {
      enable = true;
    };
  };

  launchd.user.agents.i2pd = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.i2pd}/bin/i2pd"
        "--datadir=/Users/frank/.i2pd"
        "--certsdir=${pkgs.i2pd}/share/i2pd/certificates"
        "--http.address=127.0.0.1"
        "--httpproxy.address=127.0.0.1"
        "--socksproxy.address=127.0.0.1"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/i2pd.log";
      StandardErrorPath = "/tmp/i2pd.log";
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
    bat
    fish
    fzf
    git
    lazygit
    neovim
    tldr
    yazi
  ];
}
