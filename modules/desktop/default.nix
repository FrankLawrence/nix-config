{ config, pkgs, inputs, ... }:

{

  imports = [
    ./x11.nix
    ./ani-cli.nix
  ];
}
