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
      {
        args = [ "compile" "$ZED_FILE" ];
        command = "${pkgs.typst}/bin/typst";
        label = "Typst: Compile";
        reveal = "on_success";
      }
      {
        args = [ "watch" "$ZED_FILE" ];
        command = "${pkgs.typst}/bin/typst";
        label = "Typst: Watch";
        reveal = "on_success";
      }
      {
        args = [ "$\{ZED_STEM\}.pdf" ];
        command = "open";
        label = "Typst: Preview";
        reveal = "on_success";
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
        mode = "system";
        light = "One Dark";
        dark = "Rosé Pine";
      };
      terminal = {
        shell = {
          with_arguments = {
            program = "${pkgs.fish}/bin/fish";
            args = ["--login"];
          };
        };
      };
    };
  };
}
