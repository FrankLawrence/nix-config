{ config, pkgs, inputs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "FrankLawrence";
        email = "frankl.am.htg@icloud.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      merge.tool = "nvimdiff";
      alias = {
        st = "status --short";
        hist = "log --oneline --graph --all";
      };
    };
  };
}
