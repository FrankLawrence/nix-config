{ config, lib, ...}:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ".." = "z ..";
      "..." = "z ../..";
      "...." = "z ../../..";
      ".3" = "z ../../..";
      ".4" = "z ../../../..";
      cp = "cp -i";
      rm = "rm -i";
      mv = "mv -i";
      ls = "eza -al --color=always --group-directories-first";
      la = "eza -a --color=always --group-directories-first";
      ll = "eza -l --color=always --group-directories-first";
      lt = "eza -aT --color=always --group-directories-first";
      "l." = "eza -a | egrep '^\\.'";
    };
  };
}
