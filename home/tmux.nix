{
  config,
  pkgs,
  lib,
  ...
}:
let
  tmux_doom_tomorrow_night_theme = ''
    # doom-tomorrow-night theme for tmux
    # Color palette from doom-tomorrow-night:
    #   #1d1f21 Background
    #   #161719 Background Alt
    #   #3f4040 Base4 (borders, inactive elements)
    #   #5c5e5e Base5
    #   #969896 Base7 (comments)
    #   #c5c8c6 Foreground
    #   #cc6666 Red (variables)
    #   #de935f Orange (constants, numbers)
    #   #f0c674 Yellow (types)
    #   #b5bd68 Green (strings)
    #   #8abeb7 Cyan
    #   #81a2be Blue (functions, highlights)
    #   #b294bb Violet (keywords)
    #   #c9b4cf Magenta
    #   #5a5b5a Grey (comments)

    ## Set status bar
    set -g status-style bg="#1d1f21",fg="#c5c8c6"
    setw -g window-status-current-style bg="#1d1f21",fg="#81a2be",bold

    ## Pane border and colors
    set -g pane-active-border-style bg=default,fg="#969896"
    set -g pane-border-style bg=default,fg="#3f4040"

    ## Clock mode
    set -g clock-mode-colour "#81a2be"
    set -g clock-mode-style 24

    ## Message style (command prompt)
    set -g message-style bg="#8abeb7",fg="#1d1f21",bold
    set -g message-command-style bg="#8abeb7",fg="#1d1f21"

    ## Copy mode style
    set -g mode-style bg="#3f4040",fg="#de935f"

    ## Status bar - left side
    set -g status-left-length 100
    set -g status-left '#[fg=#b294bb,bg=#1d1f21,bold] #S #[fg=#81a2be]#{?client_prefix,#[fg=#de935f],} '

    ## Status bar - right side
    set -g status-right-length 100
    set -g status-right '#[fg=#969896,bg=#1d1f21] %H:%M #[fg=#81a2be]|#[fg=#969896] %Y.%m.%d '

    ## Window status format (inactive windows)
    set-window-option -g window-status-style bg="#1d1f21",fg="#969896",none
    set-window-option -g window-status-format '#[fg=#5a5b5a,bg=#1d1f21] #I #[fg=#969896,bg=#1d1f21] #W#{?window_flags,#{window_flags}, } '

    ## Window status format (active window)
    set-window-option -g window-status-current-style bg="#1d1f21",fg="#81a2be",bold
    set-window-option -g window-status-current-format '#[fg=#b294bb,bg=#1d1f21,bold] #I #[fg=#c5c8c6,bg=#1d1f21] #W#{?window_flags,#{window_flags}, } '

    ## Window status activity
    setw -g window-status-activity-style fg="#de935f",bg="#1d1f21",none

    ## Window status bell
    setw -g window-status-bell-style fg="#cc6666",bg="#1d1f21",bold

    ## Status position
    set -g status-position bottom
    set -g status-justify left
  '';
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-Space";
    escapeTime = 10;
    baseIndex = 1;
    mouse = true;
    historyLimit = 50000;
    focusEvents = true;
    aggressiveResize = true;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
          set -g @continuum-boot 'off'
        '';
      }
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm-kitty:RGB"
      set-option -g renumber-windows on
      set -g window-size latest

      # split panes using cwd
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # navigation between windows
      bind -n M-H previous-window
      bind -n M-L next-window
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # copy mode: <prefix> + [
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      ${tmux_doom_tomorrow_night_theme}
    '';
  };
}
