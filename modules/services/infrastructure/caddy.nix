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
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';
    
    virtualHosts = {
      "proxmox.wurt.net" = {
        extraConfig = ''
          reverse_proxy beelink.tailc21299.ts.net:8006
        '';
      };
      # "service2.yourdomain.com" = {
      #   extraConfig = ''
      #     reverse_proxy localhost:9090
      #   '';
      # };
    };
    environmentFile = config.age.secrets.caddy.path;
  };
}
