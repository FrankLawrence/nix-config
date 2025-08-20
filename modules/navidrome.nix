{ config, pkgs, ...}:

{
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/mnt/nfs/music/";
      Port = 4533;
      ScanSchedule = "@every 1h";
      Address = "0.0.0.0";
      DataFolder = "/var/lib/navidrome";
      CacheFolder = "/var/cache/navidrome";
      LogLevel = "debug";
      BaseUrl = "https://navidrome.wurt.net";
    };
    openFirewall = true;
  };
}
