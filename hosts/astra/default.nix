{
  pkgs,
  lib,
  config,
  inputs,
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
      enable = true;
      active_color = "#EB6F92";
      blur_radius = 5.0;
      width = 3.0;
    };
    aerospace = {
      enable = true;
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
