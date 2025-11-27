{ config, pkgs, ... }:
{
  age.secrets.your_spotify = {
    file = ../../../secrets/your_spotify.age;
    owner = "your_spotify";
    group = "your_spotify";
  };

  services.your_spotify = {
    enable = true;
    enableLocalDB = true;
    settings = {
      spotifySecretFile = config.age.secrets.your_spotify.path;
      SPOTIFY_PUBLIC = "a0c372ab84174f4d9c690bdaa7fbce89";
      API_ENDPOINT = "http://localhost:4000";
      CLIENT_ENDPOINT = "https://spotify.wurt.net";
      PORT = 4000;
    };
  };
}
