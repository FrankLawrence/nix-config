{ config, pkgs, ... }:
let
  caddyWithPlugins = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
    hash = "sha256-Q0lgI8MY90u/5R/xXBVPQWCZBN7dUZ0kcuDxD0xd0fo=";
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

  mkProtectedProxyPublicPaths = publicPaths: upstream:
  	let paths = builtins.concatStringsSep " " publicPaths;
	  in ''
			@protected not path ${paths}
	    forward_auth @protected 127.0.0.1:5000 {
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
        extraConfig = mkProxy ''
          https://beelink.tailc21299.ts.net:8006 {
            transport http {
              tls_insecure_skip_verify
            }
            header_up Host {upstream_hostport}
          }'';
        serverAliases = [ "beelink.wurt.net" ];
      };
      # ── Infrastructure ─────────────────────────────────────────────────────
      "auth.wurt.net".extraConfig       = mkProxy          "127.0.0.1:5000";
      "pocket-id.wurt.net".extraConfig  = mkProxy          "127.0.0.1:5010";
      "forgejo.wurt.net".extraConfig    = mkProxy          "127.0.0.1:5020";
      "immich.wurt.net".extraConfig     = mkProxy          "127.0.0.1:5030";
      "syncthing.wurt.net".extraConfig  = mkProxy          "127.0.0.1:5040";
      "lldap.wurt.net".extraConfig      = mkProxy          "127.0.0.1:5050";
      "pgadmin.wurt.net".extraConfig    = mkProtectedProxy "127.0.0.1:5060";
      "grafana.wurt.net".extraConfig    = mkProtectedProxy "127.0.0.1:5070";
      # ── Media ──────────────────────────────────────────────────────────────
      "navidrome.wurt.net".extraConfig  = mkProxy "127.0.0.1:2000";
      "kavita.wurt.net".extraConfig     = mkProxy "127.0.0.1:2010";
      "komga.wurt.net".extraConfig      = mkProxy "127.0.0.1:2020";
      "audio.wurt.net".extraConfig      = ''
	      encode gzip zstd
				reverse_proxy 127.0.0.1:2030
				${tls}
      '';
      "calibre.wurt.net".extraConfig    = mkProxy "[::1]:2040";
      # ── Productivity ───────────────────────────────────────────────────────
      "glance.wurt.net" = {
        extraConfig   = mkProxy "127.0.0.1:3000";
        serverAliases = [ "home.wurt.net" ];
      };
      "stirling-pdf.wurt.net" = {
        extraConfig   = mkProxy "127.0.0.1:3010";
        serverAliases = [ "pdf.wurt.net" "stirling.wurt.net" ];
      };
      "paperless.wurt.net".extraConfig = mkProtectedProxy "127.0.0.1:3020";
      "vikunja.wurt.net".extraConfig   = mkProtectedProxy "127.0.0.1:3030";
      "actual.wurt.net".extraConfig    = mkProxy          "127.0.0.1:3040";
      "karakeep.wurt.net".extraConfig  = mkProtectedProxy "127.0.0.1:3050";
      "mealie.wurt.net".extraConfig    = mkProtectedProxyPublicPaths [ "/g/*" "/api/public/" "/api/recipes/shared/*" ] "127.0.0.1:3060";
      "freshrss.wurt.net".extraConfig  = mkProxy          "127.0.0.1:3070";
      "bento.wurt.net".extraConfig     = mkProxy          "127.0.0.1:3080";
      # ── Utility ────────────────────────────────────────────────────────────
      "adguard.wurt.net".extraConfig   = mkProxy          "127.0.0.1:4000";
      "dawarich.wurt.net".extraConfig  = mkProxy          "127.0.0.1:4010";
      "home-assistant.wurt.net".extraConfig = mkProxy     "[::1]:4020";
    };

    environmentFile = config.age.secrets.caddy.path;
  };
}
