{ config, pkgs, ... }:
let
  caddyWithPlugins = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
    hash = "sha256-vNSHU7txQLs0m0UChuszURXjEoMj4r1902+1ei0/DaI=";
  };

  tls = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      resolvers 1.1.1.1
    }
  '';

  mkProxy = upstream: ''
    reverse_proxy ${upstream}
    ${tls}
  '';

  mkProtectedProxy = upstream: ''
    forward_auth 127.0.0.1:5000 {
      uri /api/auth/caddy
      copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
    }
    reverse_proxy ${upstream}
    ${tls}
  '';
in
{
  age.secrets.caddy = {
    file = ../../../secrets/reverse-proxy.age;
    owner = "caddy";
    group = "caddy";
  };

  services.caddy = {
    enable  = true;
    package = caddyWithPlugins;

    globalConfig = ''
      debug
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';

    virtualHosts = {
      "proxmox.wurt.net" = {
        extraConfig = ''
          reverse_proxy https://beelink.tailc21299.ts.net:8006 {
            transport http {
              tls_insecure_skip_verify
            }
            header_up Host {upstream_hostport}
          }
          ${tls}
        '';
        serverAliases = [ "beelink.wurt.net" ];
      };
      # ── Infrastructure ─────────────────────────────────────────────────────
      "auth.wurt.net".extraConfig       = mkProxy "127.0.0.1:5000";
      "pocket-id.wurt.net".extraConfig  = mkProxy "127.0.0.1:5010";
      "forgejo.wurt.net".extraConfig    = mkProxy "127.0.0.1:5020";
      "immich.wurt.net".extraConfig     = mkProxy "127.0.0.1:5030";
      "syncthing.wurt.net".extraConfig  = mkProxy "127.0.0.1:5040";
      "lldap.wurt.net".extraConfig      = mkProxy "127.0.0.1:5050";
      # ── Media ──────────────────────────────────────────────────────────────
      "navidrome.wurt.net".extraConfig  = mkProxy "127.0.0.1:2000";
      "kavita.wurt.net".extraConfig     = mkProxy "127.0.0.1:2010";
      "komga.wurt.net".extraConfig      = mkProxy "127.0.0.1:2020";
      # ── Productivity ───────────────────────────────────────────────────────
      "glance.wurt.net" = {
        extraConfig   = mkProxy "127.0.0.1:3000";
        serverAliases = [ "home.wurt.net" ];
      };
      "stirling-pdf.wurt.net" = {
        extraConfig   = mkProxy "127.0.0.1:3010";
        serverAliases = [ "pdf.wurt.net" "stirling.wurt.net" ];
      };
      "paperless.wurt.net".extraConfig = mkProxy          "127.0.0.1:3020";
      "vikunja.wurt.net".extraConfig   = mkProtectedProxy "127.0.0.1:3030";
      "actual.wurt.net".extraConfig    = mkProxy          "127.0.0.1:3040";
      "karakeep.wurt.net".extraConfig  = mkProxy          "127.0.0.1:3050";
      "mealie.wurt.net".extraConfig    = mkProtectedProxy "127.0.0.1:3060";
      # ── Utility ────────────────────────────────────────────────────────────
      "adguard.wurt.net".extraConfig   = mkProxy          "127.0.0.1:4000";
      "darawich.wurt.net".extraConfig  = mkProtectedProxy "127.0.0.1:4010";

    };

    environmentFile = config.age.secrets.caddy.path;
  };
}
