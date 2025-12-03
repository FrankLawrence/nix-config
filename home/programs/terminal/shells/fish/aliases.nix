{ config, pkgs, lib, ... }:
{
  programs.fish.shellAliases = {
    # spark aliases
    clear = "command clear; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo";

    # Navigation
    ".."   = "z ..";
    "..."  = "z ../..";
    "...." = "z ../../..";
    ".3"   = "z ../../..";
    ".4"   = "z ../../../..";
    ".5"   = "z ../../../../..";

    # Confirm before overwriting
    cp = "cp -i";
    rm = "rm -i";
    mv = "mv -i";

    # Changing "ls" to "eza"
    ls   = "eza -al --color=always --group-directories-first";
    la   = "eza -a --color=always --group-directories-first";
    ll   = "eza -l --color=always --group-directories-first";
    lt   = "eza -aT --color=always --group-directories-first";
    "l." = "eza -a | egrep '^\\.'";

    # root privileges
    doas = "doas --";
    
    # colorized grep output
    grep = "grep --color=auto";
    df   = "df -h";

    # fzf with custom options (use fzfx to avoid conflicts)
    fzfx = "fzf -m \
      --info=inline \
      --pointer='→' \
      --preview='ls {+}' \
      --preview-window=border-left \
      --margin=5%,2%,7%,2% \
      --layout=reverse \
      --border=rounded \
      --header='CTRL-c or ESC to quit' \
      --height=50% \
      --bind='ctrl-r:reload(fd -td -H)' \
      --bind='ctrl-x:execute(rm -ri {+})' \
      --bind='ctrl-x:+reload(fd -td -H)' \
      --bind='ctrl-v:change-preview(lt {+} --level=2)' \
      --bind='ctrl-s:toggle-preview' \
      --bind='ctrl-f:change-prompt(Files > )' \
      --bind='ctrl-f:+change-preview(bat --color=always --style=header,grid --line-range :500 {+})' \
      --bind='ctrl-f:+reload(fd -tf -H)' \
      --bind='ctrl-d:change-prompt(Dirs > )' \
      --bind='ctrl-d:+change-preview(ls {+})' \
      --bind='ctrl-d:+reload(fd -td -H)' \
      --bind='ctrl-p:change-preview-window(up,50%,border-bottom|right,50%,border-left)' \
    ";

    bat = "bat --theme=base16";

    # process monitoring
    psmem   = "ps aux | sort -nr -k 4";
    psmem10 = "ps aux | sort -nr -k 4 | head -10";
    pscpu   = "ps aux | sort -nr -k 3";
    pscpu10 = "ps aux | sort -nr -k 3 | head -10";

    # git
    addup    = "git add -u";
    addall   = "git add -A";
    branch   = "git branch";
    checkout = "git checkout";
    clone    = "git clone";
    commit   = "git commit -m";
    fetch    = "git fetch";
    pull     = "git pull origin";
    push     = "git push origin";
    tag      = "git tag";
    newtag   = "git tag -a";

    # gpg encryption
    gpg-check    = "gpg2 --keyserver-options auto-key-retrieve --verify";
    gpg-retrieve = "gpg2 --keyserver-options auto-key-retrieve --receive-keys";

    # youtube-dl
    yta-mp3  = "yt-dlp --extract-audio --audio-format mp3 ";
    ytv-best = "yt-dlp -f bestvideo+bestaudio ";

    # bare git repo for dotfiles
    config = "/usr/bin/env git --git-dir=$HOME/.config/.git --work-tree=$HOME/.config";

    # termbin
    tb = "nc termbin.com 9999";

    # Vim Exit
    ":q" = "exit";

    vim = "NVIM_APPNAME=\"nvim_bak\" nvim";
  };
}
