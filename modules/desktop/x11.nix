{ config, pkgs, inputs, ... }:

{
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    gnome.gnome-keyring.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };
  security.polkit.enable = true;
  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    swaybg
    font-awesome
    font-awesome_4
  ];
}
