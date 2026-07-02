
{ config, lib, pkgs, ... }:
let
  cfg = config.services.bentopdf;

  bentopdf-pkg = pkgs.fetchzip {
    url  = "https://github.com/alam00000/bentopdf/releases/download/v2.8.5/dist-simple-2.8.5.zip";
    hash = "sha256-j1U9Q0tnTt4LCb+iv1uPzkCm1aYwcWeONKGxMKR5zRs=";
    stripRoot = false;
  };

in {
  options.services.bentopdf = {
    enable = lib.mkEnableOption "BentoPDF — privacy-first PDF toolkit";

    port = lib.mkOption {
      type        = lib.types.port;
      default     = 3080;
      description = "TCP port nginx will listen on.";
    };

    host = lib.mkOption {
      type        = lib.types.str;
      default     = "127.0.0.1";
      description = "Address nginx will bind to. Use \"0.0.0.0\" to listen on all interfaces.";
    };

    openFirewall = lib.mkOption {
      type    = lib.types.bool;
      default = false;
      description = "Open the firewall for the configured port.";
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts =
      lib.mkIf cfg.openFirewall [ cfg.port ];

    services.nginx = {
      enable = true;

      # SharedArrayBuffer (used by the LibreOffice WASM engine) requires these.
      appendHttpConfig = ''
        add_header Cross-Origin-Opener-Policy  "same-origin" always;
        add_header Cross-Origin-Embedder-Policy "require-corp" always;
      '';

      virtualHosts."bentopdf" = {
        listen = [{ addr = cfg.host; port = cfg.port; }];
        root   = "${bentopdf-pkg}";

        extraConfig = ''
          gzip_static on;

          location / {
            try_files $uri $uri/ /index.html;
          }

          location ~* \.(js|css|woff2?|png|svg|ico|webp)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
            add_header Cross-Origin-Opener-Policy  "same-origin" always;
            add_header Cross-Origin-Embedder-Policy "require-corp" always;
          }
        '';
      };
    };
  };
}
