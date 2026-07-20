{ config, lib, pkgs, ... }:
lib.mkIf config.services.adguardhome.enable {
  services.adguardhome = {
    # port = 3000;
    port = 4000;
    mutableSettings = true;
    host = "127.0.0.1";
    settings = {
      dhcp = {
        enabled = true;
        interface_name = "enp1s0";        # the LAN interface to serve on
        dhcpv4 = {
          gateway_ip   = "192.168.1.1";
          subnet_mask  = "255.255.255.0";
          range_start  = "192.168.1.100";
          range_end    = "192.168.1.200";
          lease_duration = 86400;
        };
      };
      users = [
        {
          name = "frank";
          password = "$2y$10$7rhIYZmrVXzNTIBdmRghRu8yoRXuj63gSweFXkVW2d3bacxryf2Ti";
				}
      ];
    };
    openFirewall = true;
  };

  networking.firewall.allowedUDPPorts = [ 53 ];
}
