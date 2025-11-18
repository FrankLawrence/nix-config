{ config, pkgs, inputs, ... }:
{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      pull.rebase = false;
      user = {
        name = "FrankLawrence";
        email = "frankl.am.htg@icloud.com";
      };
      alias = {
        st = "status --short";
        hist = "log --oneline --graph --all";
      };
      core.editor = "nvim";
      merge.tool = "nvimdiff";
    };
  };
}
