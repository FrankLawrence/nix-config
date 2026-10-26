let
  astra    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYi2ARdQqa9UnHLT4KevormEqYspMEJn6UwhPsZ77BT frank@astra";
  centauri = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlRx4b+zeii+dnPh+tjKviI7wMBhdAjp6uM3OHO9RzY frank@centauri";
  jupiter  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqo8Zt8cZd7HfI0KkPxDHGfUyAF7mFcottMa7YlLHuv frank@jupiter";
  terra    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLxYWRdvzd01GebtUTxUgLO6F5z/ricceiy6Gs6IU/H frank@terra";

  users = [ terra astra jupiter ];
  systems = [ centauri ];
in
{
  "dawarich-secret-key.age".publicKeys = users ++ systems;
  "dawarich.age".publicKeys            = users ++ systems;
  "freshrss-secret.age".publicKeys     = users ++ systems;
  "grafana.age".publicKeys             = users ++ systems;
  "karakeep.age".publicKeys            = users ++ systems;
  "kavita.age".publicKeys              = users ++ systems;
  "lldap-observer.age".publicKeys      = users ++ systems;
  "lldap-user.age".publicKeys          = users ++ systems;
  "lldap.age".publicKeys               = users ++ systems;
  "mealie.age".publicKeys              = users ++ systems;
  "navidrome.age".publicKeys           = users ++ systems;
  "paperless-oidc.age".publicKeys      = users ++ systems;
  "paperless.age".publicKeys           = users ++ systems;
  "pgadmin.age".publicKeys             = users ++ systems;
  "pocket-id.age".publicKeys           = users ++ systems;
  "restic.age".publicKeys              = users ++ systems;
  "reverse-proxy.age".publicKeys       = users ++ systems;
  "slskd.age".publicKeys               = users ++ systems;
  "tinyauth.age".publicKeys            = users ++ systems;
  "wg-astra-private.age".publicKeys    = [ astra ];
  "wg-astra-preshare.age".publicKeys   = [ astra ];
}
