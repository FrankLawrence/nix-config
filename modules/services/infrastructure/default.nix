{ ... }:

{
  imports = [
    ./caddy.nix
    ./forgejo.nix
    ./immich.nix
    ./lldap.nix
    ./pocket-id.nix
    ./postgresql.nix
    ./syncthing.nix
    ./tinyauth.nix
    ./pgadmin.nix
  ];
}
