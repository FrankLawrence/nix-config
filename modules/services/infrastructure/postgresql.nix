{ lib, pkgs, ... }:
{
  services.postgresql = {
    package = pkgs.postgresql_17;
    ensureUsers = [
      {
        name = "frank";
        ensureClauses = {
	        superuser = true;
        };
      }
    ];
    settings = {
      port = 5432;
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
    };
  };
}
