{ config, pkgs, ... }:

{

  users.users.navidrome = {
    extraGroups = [ "media" ];
  };

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/media/music/";
      Port = 5001;
      ScanSchedule = "@every 1h";
      Address = "0.0.0.0";
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
      DefaultTheme = "Dark";
    };
    openFirewall = true;
  };
}
