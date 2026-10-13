{ config, pkgs, inputs, ... }:
let
  kittyIcon = pkgs.fetchurl {
    url = "https://github.com/rose-pine/kitty/blob/main/icons/kitty.app.png";
    sha256 = "sha256-akLj0TBhx31SROzwmUrSflHtQ1ydhI+RzFB82yxzVpo=";
  };
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    shellIntegration = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    enableGitIntegration = true;
    settings = {
      window_padding_width = 10;
      hide_window_decorations = true;
      background_opacity = 0.9;
      background_blur = 10;
      editor = "nvim";
      font_size = 10.0;

      shell = "${pkgs.fish}/bin/fish --login";
    };
    autoThemeFiles = {
      light = "rose-pine-dawn";
      dark = "rose-pine";
      noPreference = "gruvbox-dark-hard";
    };
  };

  xdg.configFile."kitty/kitty.app.png".source = kittyIcon;
  xdg.configFile."kitty/themes/rose-pine.conf".source = builtins.fetchurl {
    url = "https://github.com/kovidgoyal/kitty-themes/raw/refs/heads/master/themes/rose-pine.conf";
    sha256 = "1kkib4i1i673v7gcraga5cqaixibxvhnqaixamwy5hbkhd9qb20f";
  };
  xdg.configFile."kitty/themes/rose-pine-dawn.conf".source = builtins.fetchurl {
    url = "https://github.com/kovidgoyal/kitty-themes/raw/refs/heads/master/themes/rose-pine-dawn.conf";
    sha256 = "0ykgpnnlbqb44y6ava0xi6l53w80jq5yh5mbyq18q0g3sbijsyla";
  };
}
