{ config, pkgs, lib, ...}:
{
  programs.fish = {
    enable = true;

    shellInit = ''
      # Suppress fish's intro message
      set fish_greeting
      # Set locale archive for Nix
      set LOCALE_ARCHIVE "$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"
    '';

    interactiveShellInit = ''
      # Terminal and editor settings
      set TERM xterm-256color
      set EDITOR nvim
      set VISUAL "emacsclient -c -a emacs"
      set BAT_THEME base16
      
      # FZF settings
      set FZF_CTRL_R_OPTS "--prompt 'Hist > '"
      set -Ux FZF_DEFAULT_OPTS "
        --color=fg:#908caa,bg:-1,hl:#ebbcba
        --color=fg+:#e0def4,bg+:-1,hl+:#ebbcba
        --color=border:#403d52,header:#31748f,gutter:-1
        --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
        --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
      
      # Manpager settings (nvim)
      set -x MANPAGER 'nvim +Man! -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"'
      
      # Theme settings
      fish_config theme choose "Rosé Pine"
      
      # Pager background colors
      set fish_pager_color_background --background=transparent
      set fish_pager_color_secondary_background --background=transparent
      set fish_pager_color_selected_background --background=transparent
      
      # Initialize starship prompt
      starship init fish | source
      enable_transience
      
      # Initialize zoxide
      zoxide init fish | source
      
      # Initialize kitty completions
      kitty + complete setup fish | source
    '';

    shellAliases = {
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
      doas  = "doas --";
      # colorized grep output
      grep  = "grep --color=auto";
      df    = "df -h"; # human-readable sizes

      # fzf="fzf --preview 'bat --color=always --style=header,grid --line-range :500 {}'"
      fzf = "fzf -m \
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
      # --bind='ctrl-h:change-prompt(Hist > )' \
      # --bind='ctrl-h:+reload(history)' \

      bat = "bat --theme=base16";

      ## get top process eating memory
      psmem   = "ps aux | sort -nr -k 4";
      psmem10 = "ps aux | sort -nr -k 4 | head -10";

      ## get top process eating cpu ##
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
      # verify signature for isos
      gpg-check = "gpg2 --keyserver-options auto-key-retrieve --verify";
      # receive the key of a developer
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

    functions = {
      # Spark function for sparklines
      spark = ''
        set -g spark_version 1.0.0
        
        if isatty
          switch "$argv"
            case {,-}-v{ersion,}
              echo "spark version $spark_version"
            case {,-}-h{elp,}
              echo "usage: spark [--min=<n> --max=<n>] <numbers...>  Draw sparklines"
              echo "examples:"
              echo "       spark 1 2 3 4"
              echo "       seq 100 | sort -R | spark"
              echo "       awk \\\$0=length spark.fish | spark"
            case \*
                echo $argv | spark $argv
          end
          return
        end

        command awk -v FS="[[:space:],]*" -v argv="$argv" '
          BEGIN {
            min = match(argv, /--min=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
            max = match(argv, /--max=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
          }
          {
            for (i = j = 1; i <= NF; i++) {
              if ($i ~ /^--/) continue
              if ($i !~ /^-?[0-9]/) data[count + j++] = ""
              else {
                v = data[count + j++] = int($i)
                if (max == "" && min == "") max = min = v
                if (max < v) max = v
                if (min > v ) min = v
              }
            }
            count += j - 1
          }
          END {
            n = split(min == max && max ? "▅ ▅" : "▁ ▂ ▃ ▄ ▅ ▆ ▇ █", blocks, " ")
            scale = (scale = int(256 * (max - min) / (n - 1))) ? scale : 1
            for (i = 1; i <= count; i++)
              out = out (data[i] == "" ? " " : blocks[idx = int(256 * (data[i] - min) / scale) + 1])
            print out
          }
        '
      '';
      
      # History navigation functions
      __history_previous_command = ''
        switch (commandline -t)
          case "!"
            commandline -t $history[1]
            commandline -f repaint
          case "*"
            commandline -i !
        end
      '';
      
      __history_previous_command_arguments = ''
        switch (commandline -t)
          case "!"
            commandline -t ""
            commandline -f history-token-search-backward
          case "*"
            commandline -i '$'
        end
      '';
      
      # Vi mode key bindings
      fish_user_key_bindings = ''
        fish_vi_key_bindings
        
        # Bindings for !! and !$
        if [ $fish_key_bindings = fish_vi_key_bindings ]
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
        else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
        end
      '';
    };
    
    # Spark completions
    shellAbbrs = {};
    
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf.src;
      }
    ];
  };
  
  # Spark completions (added separately)
  home.file.".config/fish/completions/spark.fish".text = ''
    complete -xc spark -n __fish_use_subcommand -a --help -d "Show usage help"
    complete -xc spark -n __fish_use_subcommand -a --version -d "1.0.0"
    complete -xc spark -n __fish_use_subcommand -a --min -d "Minimum range value"
    complete -xc spark -n __fish_use_subcommand -a --max -d "Maximum range value"
  '';
}
