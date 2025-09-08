let
  local-terra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLxYWRdvzd01GebtUTxUgLO6F5z/ricceiy6Gs6IU/H";
  users = [ local-terra ];

  homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFhP+/afrYUNByay3MeBzmBc9nZcH8bEnIQ7Z0MsURO";
  systems = [ homelab ];

  jupiter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKc+QGEfGE7T+NcAN8EkDDx3bg5z2ucrecMwbkBve2RY frank@jupiter";
in
{
  "sparkyfitness.age".publicKeys = [ local-terra homelab ];
  "immich.age".publicKeys = [ local-terra homelab ];
  "karakeep.age".publicKeys = [ local-terra homelab ];
  "kavita.age".publicKeys = [ local-terra homelab ];
  "komga.age".publicKeys = [ local-terra homelab ];
  "mealie.age".publicKeys = [ local-terra homelab ];
  "adguard.age".publicKeys = [ local-terra homelab ];
  "pocket-id.age".publicKeys = [ local-terra homelab ];
  "syncthing.age".publicKeys = [ local-terra homelab ];
}
