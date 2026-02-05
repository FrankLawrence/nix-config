{ config, pkgs, inputs, ...}:
{
  environment.systemPackages = with pkgs; [
    bat
    clang-tools
    clinfo
    compose2nix
    curl
    eza
    fd
    ffmpeg
    fish
    fzf
    gh
    git
    gopls
    htop
    lazygit
    neovim
    pyright
    ripgrep
    stylua
    tldr
    yazi
    zoxide
    lua-language-server
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
