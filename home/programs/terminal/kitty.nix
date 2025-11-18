{ config, pkgs, inputs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };
    shellIntegration.enableBashIntegration = true;
    enableGitIntegration = true;
    settings = {
      window_padding_width = 10;
      hide_window_decorations = true;
      background_opacity = 1.0;
      background_blue = 0.7;
      editor = "nvim";
      font_size = 14.0;
    };
    themeFile = "rose-pine";
  };
}
