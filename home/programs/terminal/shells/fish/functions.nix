{ config, pkgs, lib, ... }:
let
  # Import individual function files
  spark = import ./functions/spark.nix;
  history = import ./functions/history.nix;
  keybindings = import ./functions/keybindings.nix;
in
{
  programs.fish.functions = spark // history // keybindings;
}
