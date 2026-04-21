{ pkgs, ... }:
{
    programs.rofi = {
        enable = true;
        # theme = "sidebar";
        location = "center";
        cycle = true;
        font = "Fira Code";
        package = pkgs.rofi;
        modes = [
            "drun"
            "run"
            "window"
            "ssh"
        ];
        plugins = [ pkgs.rofi-calc ];
        terminal = "${pkgs.kitty}/bin/kitty";
        theme = "gruvbox-dark-hard";
        extraConfig = {
            show-icons = true;
        };
    };
}
