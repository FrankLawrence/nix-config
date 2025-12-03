{pkgs, ...}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "eaf6920b7439fa7164a1c162a249c3c76dc0acd9";
    hash = "sha256-B6zhZfp3SEaiviIzosI2aD8fk+hQF0epOTKi1qm8V3E=";
  };
in {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };
      # preview = {
      #   max_width = 1000;
      #   max_height = 1000;
      # };
    };

    plugins = {
      chmod = "${yazi-plugins}/chmod.yazi";
      full-border = "${yazi-plugins}/full-border.yazi";
      toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "d7056e37c853048a39b1fb9243d8654e60311d79";
        sha256 = "sha256-zlyJrBBUTeeGB69pMel+QWU/ivbUfzBJhGJy+yoHoaE=";
      };
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
    '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };
  };
}
