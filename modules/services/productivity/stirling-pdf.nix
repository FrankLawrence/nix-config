{ config, pkgs, ... }:

{
  services.stirling-pdf = {
    environment = {
      # SERVER_PORT = 8081;
      SERVER_PORT = 3010;
      SERVER_HOST = "127.0.0.1";
    };
  };
}
