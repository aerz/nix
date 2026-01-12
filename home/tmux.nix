{
  config,
  pkgs,
  lib,
  ...
}: let
  tmux_doom_tomorrow_night_theme = let
    bg = "#1d1f21";
    bg_alt = "#161719";
    fg = "#c5c8c6";
    base4 = "#3f4040";
    base5 = "#5c5e5e";
    base7 = "#969896";
    red = "#cc6666";
    orange = "#de935f";
    yellow = "#f0c674";
    green = "#b5bd68";
    cyan = "#8abeb7";
    blue = "#81a2be";
    violet = "#b294bb";
    magenta = "#c9b4cf";
    gray = "#5a5b5a";
  in ''
    ## Set status bar
    set -g status-style bg="${bg}",fg="${fg}"
    setw -g window-status-current-style bg="${bg}",fg="${blue}",bold

    ## Pane border and colors
    set -g pane-active-border-style bg=default,fg="${base7}"
    set -g pane-border-style bg=default,fg="${base4}"

    ## Message style (command prompt)
    set -g message-style bg="${cyan}",fg="${bg}",bold
    set -g message-command-style bg="${cyan}",fg="${bg}"

    ## Copy mode style
    set -g mode-style bg="${fg}",fg="${bg_alt}"

    ## Status bar - left side (empty)
    set -g status-left ""

    ## Status bar - right side
    set -g status-right-length 100
    set -g status-right '#[fg=${gray},]#[nobold]#W  #[fg=${fg},bg=${bg},bold]#{?client_prefix,#[fg=${violet}],}#S'

    ## Window status format (inactive windows)
    set-window-option -g window-status-style bg="${bg}",fg="${base7}",none
    set-window-option -g window-status-format '#[fg=${gray},bg=${bg}]#I #[fg=${base7},bg=${bg}]#{b:pane_current_path}#{?window_flags,#{window_flags}, }'

    ## Window status format (active window)
    set-window-option -g window-status-current-style bg="${bg}",fg="${blue}",bold
    set-window-option -g window-status-current-format '#[fg=${violet},bg=${bg},bold]#I #[fg=${fg},bg=${bg}]#{b:pane_current_path}#{?window_flags,#{window_flags}, }'

    ## Window status activity
    setw -g window-status-activity-style fg="${orange}",bg="${bg}",none

    ## Window status bell
    setw -g window-status-bell-style fg="${red}",bg="${bg}",bold

    ## Status position
    set -g status-position bottom
    set -g status-justify left
  '';
in {
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
      unbind -T copy-mode-vi MouseDragEnd1Pane

      ${tmux_doom_tomorrow_night_theme}
    '';
  };
}
