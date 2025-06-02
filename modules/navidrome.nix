{ config, pkgs, ...}

{
  serives.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "$HOME/Music/";
      Port = 4533;
      ScanSchedule =-"@every 1h";
      Address = "0.0.0.0";
    };
    openFirewall = enable;
  };
}
