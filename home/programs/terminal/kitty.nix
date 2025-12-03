{ config, pkgs, inputs, ... }:
let 
  kittyIcon = pkgs.fetchurl {
    url = "https://github.com/rose-pine/kitty/blob/main/icons/kitty.app.png";
    sha256 = "sha256-wFqfXInSJKO0mP+gbLoAVCf0vCyMTTLlHK+ekXsvrqw=";
  };
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
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

      shell = "fish -c 'tmux new-session -A -s Main'";
    };
    themeFile = "rose-pine";
  };

  home.file.".config/kitty/kitty.app.png".source = kittyIcon;
}
