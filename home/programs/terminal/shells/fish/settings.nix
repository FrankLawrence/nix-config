{ config, pkgs, lib, ... }:
{
  programs.fish = {
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
      set -x MANPAGER '/usr/bin/env bash -c "nvim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'
      
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
      
      # Initialize fzf (use command to bypass alias)
      # command fzf --fish | source
    '';

    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf.src;
      }
    ];
  };
}
