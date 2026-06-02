{ ... }:

{
  imports = [
    ./postgresql.nix
    ./pocket-id.nix
    # ./forgejo.nix
    # ./syncthing.nix
    # ./immich.nix
    ./caddy.nix
  ];
}
