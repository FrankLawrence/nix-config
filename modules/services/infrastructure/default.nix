{ ... }:

{
  imports = [
    ./caddy.nix
    ./tinyauth.nix
    ./pocket-id.nix
    ./forgejo.nix
    ./syncthing.nix
    ./immich.nix
    ./postgresql.nix
    ./lldap.nix
  ];
}
