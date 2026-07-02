{ config, lib, pkgs, ... }:
lib.mkIf config.services.home-assistant.enable {
  services.home-assistant = {
    config = {
      http = {
        server_host = [ "::1" "127.0.0.1" ];
	server_port = 4020;
	trusted_proxies = [ "::1" ];
        use_x_forwarded_for = true;
      };
    };
    openFirewall = true;
  };
}
