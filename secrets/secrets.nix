let
  local-terra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLxYWRdvzd01GebtUTxUgLO6F5z/ricceiy6Gs6IU/H";
  users = [ local-terra ];

  homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFhP+/afrYUNByay3MeBzmBc9nZcH8bEnIQ7Z0MsURO";
  systems = [ homelab ];
in
{
  "kavita.age".publicKeys = [ local-terra homelab ];
}
