{ config, pkgs, ... }: 

{
  services.stirling-pdf = {
    environment = {
      SERVER_PORT = 8081;
    };
  };
}
