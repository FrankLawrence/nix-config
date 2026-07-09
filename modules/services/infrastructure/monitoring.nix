{ pkgs, ... }:
let
  alloyConfig = pkgs.writeText "alloy.alloy" ''
    // ── Logs: journald → Loki ────────────────────────────────────────────
    loki.write "local" {
      endpoint {
        url = "http://127.0.0.1:5071/loki/api/v1/push"
      }
    }

    loki.relabel "journal" {
      forward_to = []
      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label  = "unit"
      }
      rule {
        source_labels = ["__journal__priority_keyword"]
        target_label  = "level"
      }
      rule {
        source_labels = ["__journal__hostname"]
        target_label  = "host"
      }
    }

    loki.source.journal "read" {
      forward_to    = [loki.write.local.receiver]
      relabel_rules = loki.relabel.journal.rules
      labels        = { job = "systemd-journal" }
    }
  '';
in
{
  # ── Grafana ─────────────────────────────────────────────────────────────
  services.grafana = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 5070;
        domain    = "grafana.wurt.net";
        root_url  = "https://grafana.wurt.net";
      };
      analytics.reporting_enabled = false;
      auth.oauth_allow_insecure_email_lookup = true;
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name      = "Prometheus";
          type      = "prometheus";
          url       = "http://127.0.0.1:5072";
          isDefault = true;
        }
        {
          name = "Loki";
          type = "loki";
          url  = "http://127.0.0.1:5071";
        }
      ];
    };
  };

  # ── Loki ────────────────────────────────────────────────────────────────
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server.http_listen_port = 5071;
      common = {
        instance_addr = "127.0.0.1";
        path_prefix   = "/var/lib/loki";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory  = "/var/lib/loki/rules";
        };
        replication_factor = 1;
        ring.kvstore.store = "inmemory";
      };
      schema_config.configs = [{
        from         = "2024-01-01";
        store        = "tsdb";
        object_store = "filesystem";
        schema       = "v13";
        index = {
          prefix = "loki_";
          period = "24h";
        };
      }];
      limits_config = {
        reject_old_samples         = true;
        reject_old_samples_max_age = "168h";
      };
    };
  };

  # ── Alloy (journald → Loki) ──────────────────────────────────────────────
  services.alloy = {
    enable     = true;
    configPath = alloyConfig;
  };

  # Alloy needs journal read access
  users.users.alloy.extraGroups = [ "systemd-journal" ];
  users.users.alloy.isNormalUser = true;

  # ── Prometheus ───────────────────────────────────────────────────────────
  services.prometheus = {
    enable        = true;
    port          = 5072;
    listenAddress = "127.0.0.1";
    retentionTime = "30d";
    scrapeConfigs = [
      {
        job_name       = "vikunja";
        metrics_path   = "/api/v1/metrics";
        static_configs = [{ targets = [ "127.0.0.1:3030" ]; }];
      }
      {
        job_name       = "navidrome";
        metrics_path   = "/metrics_internal";
        static_configs = [{ targets = [ "127.0.0.1:2000" ]; }];
      }
      # {
      #   job_name       = "karakeep";
      #   metrics_path   = "/api/metrics";
      #   static_configs = [{ targets = [ "127.0.0.1:3050" ]; }];
      #   # token must match PROMETHEUS_AUTH_TOKEN in karakeep.nix
      #   authorization  = {
      #     type        = "Bearer";
      #     credentials = "centauri-metrics-token";
      #   };
      # }
      {
        job_name       = "pocket-id";
        metrics_path   = "/metrics";
        static_configs = [{ targets = [ "127.0.0.1:5073" ]; }];
      }
    ];
  };
}
