{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      nixd
      coursier
      metals
      sbt
      go
    ];
    extensions = [
      "nix"
    ];
    installRemoteServer = true;
    userTasks = [
      {
        label = "Format Code";
        command = "nix";
        args = [
          "fmt"
          "$ZED_WORKTREE_ROOT"
        ];
      }
    ];
    userSettings = {
      vim_mode = true;
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      ui_font_size = 16.0;
      buffer_font_size = 13.0;
      theme = {
        mode = "dark";
        light = "One Dark";
        dark = "Ayu Dark";
      };
    };
  };
}
