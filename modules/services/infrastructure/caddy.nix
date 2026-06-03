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

  # Reverse proxy protected by tinyauth forward_auth.
  # Unauthenticated requests are redirected to Pocket ID via tinyauth.
  mkProtectedProxy = upstream: ''
    forward_auth 127.0.0.1:7070 {
      uri /api/auth
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
      "auth.wurt.net".extraConfig       = mkProxy "127.0.0.1:7070";
      "pocket-id.wurt.net".extraConfig  = mkProxy "127.0.0.1:1411";
      "adguard.wurt.net".extraConfig    = mkProxy "http://192.168.178.158:80";

      # ── Media ──────────────────────────────────────────────────────────────
      "navidrome.wurt.net".extraConfig  = mkProxy "127.0.0.1:5001";

      # ── Productivity ───────────────────────────────────────────────────────
      "glance.wurt.net" = {
        extraConfig   = mkProxy "127.0.0.1:8084";
        serverAliases = [ "home.wurt.net" ];
      };
      "stirling-pdf.wurt.net" = {
        extraConfig   = mkProxy "127.0.0.1:8081";
        serverAliases = [ "pdf.wurt.net" "stirling.wurt.net" ];
      };
      "paperless.wurt.net".extraConfig  = mkProtectedProxy "127.0.0.1:28981";
      "vikunja.wurt.net".extraConfig    = mkProtectedProxy "127.0.0.1:3456";

      # ── Utility ────────────────────────────────────────────────────────────
      "darawich.wurt.net".extraConfig   = mkProtectedProxy "127.0.0.1:3000";

      # ── Infrastructure (optional) ──────────────────────────────────────────
      "forgejo.wurt.net".extraConfig    = mkProxy "127.0.0.1:3001";
    };

    environmentFile = config.age.secrets.caddy.path;
  };
}

