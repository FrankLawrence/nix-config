{ pkgs, ...}:
{
  # programs.omniwm = {
  #   enable = true;
  #   settings = ./omniwm-settings.toml;
  # };
  xdg.configFile."omniwm/settings.toml".source = ./omniwm-settings.toml;

  launchd.agents.omniwm = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.omniwm}/bin/OmniWM" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
