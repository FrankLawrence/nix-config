{ config, pkgs, ... }:
let
  caddyWithPlugins = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
    hash = "sha256-8HpPZ/VoiV/k0ZYcnXHmkwuEYKNpURKTN19aYZRLPoM=";
  };
in
{
  age.secrets.caddy = {
    file = ../../../secrets/reverse-proxy.age;
    owner = "caddy";
    group = "caddy";
  };

  services.caddy = {
    enable = true;
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
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            resolvers 1.1.1.1
          }
        '';
        serverAliases = [
          "beelink.wurt.net"
        ];
      };
    "pocket-id.wurt.net".extraConfig = ''
      reverse_proxy localhost:1411
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        resolvers 1.1.1.1
      }
      '';
    "navidrome.wurt.net".extraConfig = ''
      reverse_proxy localhost:5001
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        resolvers 1.1.1.1
      }
      '';
    "darawich.wurt.net".extraConfig = ''
      reverse_proxy 127.0.0.1:3000
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        resolvers 1.1.1.1
      }
      '';
    };
    environmentFile = config.age.secrets.caddy.path;
  };
}
