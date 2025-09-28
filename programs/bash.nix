{ config, lib, ...};
{
  programs.bash.shellAliases = {
    ".." = "z ..";
    "ls" = "eza -al --color=always --group-directories-first";
  };
}
