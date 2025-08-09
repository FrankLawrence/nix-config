{ config, pkgs, ...}

{
  serives.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/mnt/music/";
      Port = 4533;
      ScanSchedule = "@every 1h";
      Address = "0.0.0.0";
    };
    openFirewall = enable;
  };
}
