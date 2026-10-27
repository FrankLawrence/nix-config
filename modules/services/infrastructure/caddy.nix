{ config, lib, pkgs, ... }:
let
  caddyWithPlugins = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
    hash = "sha256-dQvk6ezY6TQ1J7PjhCXnThF/SqVgPwBO8/RXzHCY+js=";
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

  # Apps behind tinyauth trust these headers, so a client must never be able to
  # send them itself. route keeps the strip before forward_auth sets them.
  authHeaders = "Remote-User Remote-Groups Remote-Name Remote-Email";
  stripAuthHeaders = ''
    request_header -Remote-User
    request_header -Remote-Groups
    request_header -Remote-Name
    request_header -Remote-Email
  '';

  mkProtectedProxy = upstream: ''
    route {
      ${stripAuthHeaders}
      forward_auth 127.0.0.1:5000 {
        uri /api/auth/caddy
        copy_headers ${authHeaders}
      }
      reverse_proxy ${upstream}
    }
    ${tls}
  '';

  mkProtectedProxyPublicPaths =
    publicPaths: upstream:
    let
      paths = builtins.concatStringsSep " " publicPaths;
    in
    ''
      @protected not path ${paths}
      route {
        ${stripAuthHeaders}
        forward_auth @protected 127.0.0.1:5000 {
          uri /api/auth/caddy
          copy_headers ${authHeaders}
        }
        reverse_proxy ${upstream}
      }
      ${tls}
    '';
in
{
  age.secrets.caddy = {
    file = ../../../secrets/reverse-proxy.age;
    owner = "caddy";
    group = "caddy";
  };

  # Services on this host call each other by public name (tinyauth -> id.wurt.net,
  # OIDC discovery, ...). Tailscale's DNS can't resolve them, so send them to caddy here.
  networking.hosts =
    let
      names = lib.concatMap (name: [ name ] ++ config.services.caddy.virtualHosts.${name}.serverAliases) (
        builtins.attrNames config.services.caddy.virtualHosts
      );
    in
    {
      "127.0.0.1" = names;
      "::1" = names;
    };

  services.caddy = {
    package = caddyWithPlugins;

    globalConfig = ''
      debug
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';

    virtualHosts = {
      "proxmox.wurt.net" = {
        extraConfig = mkProxy ''
          https://beelink.tailc21299.ts.net:8006 {
            transport http {
              tls_insecure_skip_verify
            }
            header_up Host {upstream_hostport}
          }'';
        serverAliases = [ "beelink.wurt.net" ];
      };
      "nas.wurt.net".extraConfig = mkProxy ''
        192.168.178.40:5001 {
        	transport http {
         		tls_insecure_skip_verify
          }
        }
      '';
      # ── Infrastructure ─────────────────────────────────────────────────────
      "auth.wurt.net".extraConfig       = mkProxy          "127.0.0.1:5000";
      "id.wurt.net".extraConfig         = mkProxy          "127.0.0.1:5010";
      "forgejo.wurt.net".extraConfig    = mkProxy          "127.0.0.1:5020";
      "syncthing.wurt.net".extraConfig  = mkProxy          "127.0.0.1:5040";
      "lldap.wurt.net".extraConfig      = mkProxy          "127.0.0.1:5050";
      "grafana.wurt.net".extraConfig    = mkProtectedProxy "127.0.0.1:5070";
      # ── Media ──────────────────────────────────────────────────────────────
      # "navidrome.wurt.net".extraConfig   = mkProtectedProxyPublicPaths [ "/rest/*" "/share/*" ] "127.0.0.1:2000"; # Subsonic apps use their own password
      "navidrome.wurt.net".extraConfig = mkProxy "127.0.0.1:2000"; # Subsonic apps use their own password
      "kavita.wurt.net".extraConfig    = mkProxy "127.0.0.1:2010";
      "komga.wurt.net".extraConfig     = mkProxy "127.0.0.1:2020";
      "audio.wurt.net".extraConfig = ''
        encode gzip zstd
        reverse_proxy 127.0.0.1:2030
        ${tls}
      '';
      "calibre.wurt.net".extraConfig     = mkProxy "[::1]:2040";
      "lidarr.wurt.net".extraConfig      = mkProtectedProxy "127.0.0.1:2050";
      "slskd.wurt.net".extraConfig       = mkProxy "127.0.0.1:2051";
      "qbittorrent.wurt.net".extraConfig = mkProtectedProxy "127.0.0.1:2052";
      "jellyfin.wurt.net".extraConfig    = mkProxy "127.0.0.1:8096";
      "suwayomi.wurt.net".extraConfig    = mkProtectedProxy "127.0.0.1:2060";
      "immich.wurt.net".extraConfig      = mkProxy "127.0.0.1:2070";
      # ── Productivity ───────────────────────────────────────────────────────
      "glance.wurt.net" = {
        extraConfig = mkProxy "127.0.0.1:3000";
        serverAliases = [ "home.wurt.net" ];
      };
      "stirling-pdf.wurt.net" = {
        extraConfig   = mkProxy "127.0.0.1:3010";
        serverAliases = [ "pdf.wurt.net" "stirling.wurt.net" ];
      };
      "paperless.wurt.net".extraConfig = mkProxy          "127.0.0.1:3020";
      "vikunja.wurt.net".extraConfig   = mkProxy          "127.0.0.1:3030";
      "actual.wurt.net".extraConfig    = mkProxy          "127.0.0.1:3040";
      "karakeep.wurt.net".extraConfig  = mkProxy          "127.0.0.1:3050";
      "mealie.wurt.net".extraConfig    = mkProxy          "127.0.0.1:3060";
      "freshrss.wurt.net".extraConfig  = mkProxy          "127.0.0.1:3070";
      "bento.wurt.net".extraConfig     = mkProxy          "127.0.0.1:3080";
      # ── Utility ────────────────────────────────────────────────────────────
      "adguard.wurt.net".extraConfig   = mkProtectedProxy "127.0.0.1:4000";
      "dawarich.wurt.net".extraConfig  = mkProxy          "127.0.0.1:4010";
      "home-assistant.wurt.net".extraConfig = mkProxy     "127.0.0.1:4020";
    };

    environmentFile = config.age.secrets.caddy.path;
  };
}
