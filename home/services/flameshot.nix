{ pkgs, config, ... }:
{
    services.flameshot = {
        enable = true;
        settings = {
            General = {
                useGrimAdapter = true;
                disableGrimWarning = true;
                savePath = "/home/frank/Pictures/Screenshots";
                showStartupLaunchMessage = true;
            };
        };
    };
}
