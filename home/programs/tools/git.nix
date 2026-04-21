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
        logbranches = "log --graph --all --date=format:'%Y-%m-%d %H:%I:%S' --format=format:'%C(3)%>|(26)%h%C(reset)  %C(12)%ad%C(reset)  %C(2)%<(16,trunc)%an%C(reset)  %C(bold 1)%d%C(reset) %C(8)%>|(1)%s%C(reset)'";
      };
    };
  };
}
