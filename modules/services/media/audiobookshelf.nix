{ config, lib, pkgs, ... }:
{
	services.audiobookshelf = {
		port = 2030;
		host = "127.0.0.1";
	};
}
