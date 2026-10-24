{ inputs, ... }:

{
  imports = [ inputs.areofyl-fetch.homeManagerModules.default ];

  programs.fetch = {
    enable = true;
    labelColor = "red";
    info = [
      "os"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "display"
      "wm"
      "theme"
      "font"
      "terminal"
      "cpu"
      "gpu"
      "memory"
      "disk"
      "ip"
    ];
    speed = 1.0;
    spin = "xy";
  };

}
