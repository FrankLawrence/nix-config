{ config, pkgs, inputs, ... }:
{
  programs.git = {
    enable = true;
    userName = "FrankLawrence";
    userEmail = "frankl.am.htg@icloud.com";
    aliases = {
        st = "status --short";
        hist = "log --oneline --graph --all";
    };
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      merge.tool = "nvimdiff";
    };
  };
}
