{ config, lib, pkgs, ... }:
lib.mkIf config.services.calibre-web.enable {
	services.calibre-web = {
		listen = {
			ip = "127.0.0.1";
			port = 2040;
		};

		options = {
			enableBookUploading = true;
			enableKepubify = true;
			reverseProxyAuth.enable = true;
			calibreLibrary = config.services.calibre-server.libraries;
		};
		openFirewall = true;
	};

	services.calibre-server = {
		port = 2041;
		host = "::1";
		libraries = [ "/var/lib/calibre-server" ];
		openFirewall = true;
	};
}
