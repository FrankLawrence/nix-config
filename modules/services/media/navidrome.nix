{ config, lib, pkgs, ... }:
{

  users.users.navidrome = {
    extraGroups = [ "media" ];
  };

  age.secrets.navidrome = {
    file = ../../../secrets/navidrome.age;
    owner = "navidrome";
    group = "navidrome";
  };

  services.navidrome = {
    environmentFile = config.age.secrets.navidrome.path;
    settings = {
      MusicFolder = "/media/music/";
      # Port = 5001;
      Port = 2000;
      ScanSchedule = "@every 1h";
      Address = "127.0.0.1";
      DataFolder = "/var/lib/navidrome";
      CacheFolder = "/var/cache/navidrome";
      LogLevel = "info";
      BaseUrl = "https://navidrome.wurt.net";
      Agents = "lastfm,listenbrainz";
      Backup = {
        Path = "/home/frank/backup/";
        Schedule = "0 0 * * *";
        Count = 5;
      };
      ExtAuth = {
        TrustedSources = "127.0.0.1/32";
				UserHeader = "X-Auth-Request-User";
      };
      DefaultTheme = "Dark";
      Prometheus = {
        Enabled     = true;
        MetricsPath = "/metrics_internal";
      };
    };
    openFirewall = true;
  };
}
