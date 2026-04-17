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
      agent_buffer_font_size = 20.0;
      agent_ui_font_size = 20.0;
      agent = {
        always_allow_tool_actions = false;
        default_model = {
          provider = "ollama";
          model = "codegemma:7b";
        };
        model_parameters = [ ];
      };
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      ui_font_size = 19.0;
      buffer_font_size = 17.0;
      theme = {
        mode = "dark";
        light = "One Dark";
        dark = "Ayu Dark";
      };
    };
  };
}
