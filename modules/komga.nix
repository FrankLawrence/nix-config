{
  services.komga = {
    enable = true;
    settings = {
      server.port = 8082;
      komga.oauth2-account-creation = true;
    };
  };
}
