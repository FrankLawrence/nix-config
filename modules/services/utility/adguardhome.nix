{ config, lib, ... }:
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
      # No users: the web UI only listens on localhost, tinyauth guards it through caddy
      users = [ ];
    };
  };

  networking.firewall.allowedUDPPorts = [ 53 ];
}
