{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    shellInit = ''
      set fish_greeting
    '';

    interactiveShellInit = ''
      fish_config theme choose "rose-pine-auto"

      set fish_pager_color_background --background=transparent
      set fish_pager_color_secondary_background --background=transparent
      set fish_pager_color_selected_background --background=transparent

      # absolute path so it works even if PATH is incomplete
      ${pkgs.kitty}/bin/kitty + complete setup fish | source
      ${pkgs.devenv}/bin/devenv hook fish | source
    '';

    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf.src; }
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "emacsclient -c -a emacs";
    BAT_THEME = "base16";
    NH_DARWIN_FLAKE = "/Users/frank/nix-config/";
    FZF_CTRL_R_OPTS = "--prompt 'Hist > '";
    # FZF_DEFAULT_OPTS = ''
    #   --color=fg:#908caa,bg:-1,hl:#ebbcba
    #   --color=fg+:#e0def4,bg+:-1,hl+:#ebbcba
    #   --color=border:#403d52,header:#31748f,gutter:-1
    #   --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
    #   --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
    # '';
  };

  xdg.configFile."fish/themes/rose-pine-auto.theme".source = ./rose-pine-auto.theme;
}
