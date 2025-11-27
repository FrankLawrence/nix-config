{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    historyLimit = 100000;
    disableConfirmationPrompt = true;
    baseIndex = 1;
    mouse = true;
    newSession = true;
    prefix = "C-Space";
    shortcut = "Space";
    plugins = with pkgs;
      [
        tmuxPlugins.better-mouse-mode
	tmuxPlugins.sensible
	tmuxPlugins.yank
	{
	  plugin = tmuxPlugins.rose-pine;
	  extraConfig = ''
	  set -g @rose_pine_variant 'moon'                  # Options are 'main', 'moon' or 'dawn'
	  set -g @rose_pine_date_time '%d.%m %H:%M'         # It accepts the date UNIX command format (man date for info)
	  set -g @rose_pine_bar_bg_disable 'on'             # Disables background color, for transparent terminal emulators
	  set -g @rose_pine_show_current_program 'on'       # Forces tmux to show the current running program as window name

	  # set -g @rose_pine_directory 'on'                  # Turn on the current folder component in the statusbar
	  set -g @rose_pine_field_separator ' | '           # Again, 1-space padding, it updates with prefix + I
	  set -g @rose_pine_only_windows 'off'              # Leaves only the window module, for max focus and space
	  set -g @rose_pine_disable_active_window_menu 'on' # Disables the menu that shows the active window on the left
	  set -g @rose_pine_user 'on'                       # Turn on the username component in the statusbar
	  '';
	}
	{
	  plugin = tmuxPlugins.resurrect;
	  extraConfig = ''
	    set -g @resurrect-strategy-vim 'session'
	    set -g @resurrect-strategy-nvim 'session'
	    set -g @resurrect-capture-pane-contents 'on'
	  '';
	}
	{
	  plugin = tmuxPlugins.continuum;
	  extraConfig = ''
	    set -g @continuum-restore 'on'
	    set -g @continuum-boot 'on'
	    set -g @continuum-save-interval '10'
	  '';
	}
	tmuxPlugins.pass
	tmuxPlugins.vim-tmux-navigator
      ];
    extraConfig = ''
    set -g status-style bg=default
    set -g pane-border-style bg=default
    set -g pane-active-border-style bg=default
    set -g status-bg default

    # yazi image preview
    set -g allow-passthrough all
    set -ga update-environment TERM
    set -ga update-environment TERM_PROGRAM

    # Vim keys for navigating panes
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    '';
  };
}
