{ config, pkgs, ...}

{
  serives.mealie = {
    enable = true;
    port = 9000;
    database.createLocally = true;
  };
}
