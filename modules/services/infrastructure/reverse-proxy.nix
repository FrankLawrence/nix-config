{ pkgs, ... }

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "wurt.net" =-{
        extraConfig = ''
          respond "hello, world"
        '';
      };
    };
  }
}
