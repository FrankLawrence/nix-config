{ pkgs, ... }:
{
  services.postgresql = {
    package = pkgs.postgresql_17;
    ensureUsers = [
      {
        name = "frank";
        ensureClauses.superuser = true;
      }
    ];
  };
}
