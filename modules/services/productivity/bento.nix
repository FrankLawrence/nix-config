{
  # Static site with no service of its own; caddy serves it from the store
  services.bentopdf = {
    domain = "bento.wurt.net";
    caddy.enable = true;
  };
}
