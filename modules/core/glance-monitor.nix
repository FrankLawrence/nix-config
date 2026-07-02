{ lib, ... }:
{
  options.custom.glance.monitoredSites = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        title     = lib.mkOption { type = lib.types.str; };
        url       = lib.mkOption { type = lib.types.str; };
        check-url = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
        icon      = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
      };
    });
    default = [];
    description = "Services auto-registered into Glance's self-hosting monitor widget.";
  };
}
