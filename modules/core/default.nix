{ pkgs, inputs, ... }:
{
  imports = [
    ./glance-monitor.nix
    ./nix.nix
    ./security.nix
    ./users.nix
    ./locale.nix
    ./timezone.nix
  ];

  environment.systemPackages = with pkgs; [
    bat
    clang-tools
    clinfo
    compose2nix
    curl
    devenv
    eza
    fd
    ffmpeg
    fish
    fzf
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
    curl
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
  ];
}
