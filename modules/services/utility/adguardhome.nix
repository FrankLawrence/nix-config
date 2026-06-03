{ config, lib, pkgs, ... }:
{
  services.adguardhome = {
    # port = 3000;
    port = 4000;
    mutableSettings = true;
    host = "127.0.0.1";
    settings = {
      dhcp.enabled = true;
      users = [
        {
          name = "frank";
          password = "$2y$10$7rhIYZmrVXzNTIBdmRghRu8yoRXuj63gSweFXkVW2d3bacxryf2Ti";
	}
      ];
    };
  };
}
