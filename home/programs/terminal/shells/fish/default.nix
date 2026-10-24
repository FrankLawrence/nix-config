{
  imports = [
    ./aliases.nix
    ./functions.nix
    ./settings.nix
    ./completions.nix
  ];

  programs.fish = {
    enable = true;
  };
}
