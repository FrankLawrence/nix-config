{ config, pkgs, inputs, ...}:
{
  environment.systemPackages = with pkgs; [
    bat
    compose2nix
    clinfo
    eza
    fd
    ffmpeg
    fish
    fzf
    gh
    git
    htop
    lazygit
    neovim
    ripgrep
    tldr
    yazi
    zoxide
    curl
    inputs.agenix.packages."${system}".default
  ];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF8";
  };
}
