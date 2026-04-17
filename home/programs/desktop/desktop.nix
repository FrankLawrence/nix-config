{ pkgs, inputs, ... }:
{
  programs = {
    dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      dgop.package = inputs.dgop.packages.${pkgs.system}.default;
      niri = {
        # enableKeybinds = true;
        enableSpawn = true;
      };
    };
    niri.enable = true;
    waybar.enable = true;
    alacritty.enable = true;
    fuzzel.enable = true;
    swaylock.enable = true;
  };
  services = {
    mako.enable = true;
    swayidle.enable = true;
    polkit-gnome.enable = true;
  };
}
