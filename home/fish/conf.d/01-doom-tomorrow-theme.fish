# Doom Tomorrow Night
# Adapted from doom-tomorrow-night-theme.el in doom-emacs
set -l background 1d1f21
set -l foreground c5c8c6
set -l comment 5a5b5a
set -l red cc6666
set -l orange de935f
set -l yellow f0c574
set -l green b5bd68
set -l aqua 8abeb7
set -l blue 81a2be
set -l violet b294bb
set -l magenta c9b4cf

set -g fish_color_command $violet
set -g fish_color_quote $green
set -g fish_color_redirection $aqua
set -g fish_color_end $violet
set -g fish_color_error $red
set -g fish_color_param normal --bold
set -g fish_color_comment $comment
set -g fish_color_operator $foreground
set -g fish_color_escape $orange
set -g fish_color_autosuggestion $comment

set -g fish_color_cwd normal --bold
set -g fish_color_cwd_root $red
set -g fish_color_valid_path --bold --underline

set -g fish_color_user $green
set -g fish_color_host $foreground

set -g fish_pager_color_prefix $violet --bold
set -g fish_pager_color_completion normal
set -g fish_pager_color_description $aqua
set -g fish_pager_color_progress $background --background=$violet

set -g fish_color_search_match $background --background=$yellow
set -g fish_color_selection $foreground --bold --background=$comment
