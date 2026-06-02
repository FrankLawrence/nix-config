{ config, lib, ... }:
{
    age.secrets.dawarich-db-pass = {
        file = ../../../secrets/dawarich-db-pass.age;
        owner = "dawarich";
    };

    age.secrets.dawarich-secret-key = {
        file = ../../../secrets/dawarich-secret-key.age;
        owner = "dawarich";
    };

    services.postgresql = {
        ensureDatabases = [ "dawarich" ];
        ensureUsers = [
            {
                name = "dawarich";
                ensureDBOwnership = true;
            }
        ];
    };

    services.redis.servers."dawarich" = {
        enable = true;
        port = 6379;
    };

    services.dawarich = {
        enable = true;
        database = {
            host = "/run/postgresql";
            name = "dawarich";
            user = "dawarich";
            passwordFile = config.age.secrets.dawarich-db-pass.path;
        };

        redis = {
            host = "localhost";
            port = 6379;
        };

        secretKeyBaseFile = config.age.secrets.dawarich-secret-key.path;

        webPort = 3000;

        # localDomain = "centauri.tailc21299.ts.net";
        localDomain = "dawarich.wurt.net";

        environment = {
            APPLICATION_HOSTS = "127.0.0.1,dawarich.wurt.net,centauri.tailc21299.ts.net";
        };
    };
}
