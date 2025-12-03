{ config, pkgs, lib, ... }:
{
  # Spark completions
  home.file.".config/fish/completions/spark.fish".text = ''
    complete -xc spark -n __fish_use_subcommand -a --help -d "Show usage help"
    complete -xc spark -n __fish_use_subcommand -a --version -d "1.0.0"
    complete -xc spark -n __fish_use_subcommand -a --min -d "Minimum range value"
    complete -xc spark -n __fish_use_subcommand -a --max -d "Maximum range value"
  '';
}
