{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    ensureUsers = [
      {
        name = "frank";
        ensureClauses.superuser = true;
      }
    ];
  };
}
