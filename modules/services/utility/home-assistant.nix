{ config, lib, ... }:
lib.mkIf config.services.home-assistant.enable {
  services.home-assistant = {
    config = {
      http = {
        server_host = [ "::1" "127.0.0.1" ];
				server_port = 4020;
				trusted_proxies = [ "::1" "127.0.0.1" ];
        use_x_forwarded_for = true;
      };
    };
    extraComponents = [
      "analytics"
      "default_config"
      "esphome"
      "my"
      "shopping_list"
      "wled"
      "homekit"
      # Only listed integrations get their Python libraries; a discovered
      # device whose integration is missing never shows up in the UI
      "apple_tv"
      "onvif"
      # Set up by onboarding
      "met"
      "radio_browser"
      "google_translate"
    ];
    openFirewall = true;
  };

  # Discovery replies come back as multicast, which the stateful firewall drops.
  # mDNS (zeroconf), SSDP, and the HomeKit bridge
  networking.firewall = {
    allowedUDPPorts = [ 5353 1900 ];
    allowedTCPPorts = [ 21063 ];
  };
}
