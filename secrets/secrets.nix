let
  local-terra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLxYWRdvzd01GebtUTxUgLO6F5z/ricceiy6Gs6IU/H";
  jupiter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKc+QGEfGE7T+NcAN8EkDDx3bg5z2ucrecMwbkBve2RY frank@jupiter";
  jupiter-agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqo8Zt8cZd7HfI0KkPxDHGfUyAF7mFcottMa7YlLHuv frank@jupiter";

  users = [ local-terra jupiter-agenix ];

  centauri = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoMROjV6+nWOiYkgOTC6MUMxVusLvp5IV8yYnG0eo6v frank@centauri";
  systems = [ centauri ];
in
{
  # "adguard.age".publicKeys        = users ++ systems;
  "oauth2-proxy.age".publicKeys = users ++ systems;
  "dawarich-db-pass.age".publicKeys    = users ++ systems;
  "dawarich-secret-key.age".publicKeys = users ++ systems;
  "dawarich.age".publicKeys = users ++ systems;
  "reverse-proxy.age".publicKeys   = users ++ systems;
  "tinyauth.age".publicKeys   = users ++ systems;
  # "immich.age".publicKeys        = users ++ systems;
  # "karakeep.age".publicKeys      = users ++ systems;
  # "kavita.age".publicKeys        = users ++ systems;
  # "komga.age".publicKeys         = users ++ systems;
  # "mealie.age".publicKeys        = users ++ systems;
  "pocket-id.age".publicKeys       = users ++ systems;
  # "sparkyfitness.age".publicKeys = users ++ systems;
  # "syncthing.age".publicKeys     = users ++ systems;
  # "your_spotify.age".publicKeys  = users;
}
