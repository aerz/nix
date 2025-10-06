{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font.name = "JetBrainsMono Nerd Font Mono";
    font.size = 15;

    settings = {
      window_padding_width = 4;
      scrollback_lines = 5000;
      disable_ligatures = "cursor";
      notify_on_cmd_finish = "unfocused";
      macos_colorspace = "displayp3";
      macos_option_as_alt = "yes";
      macos_titlebar_color = "background";

      # Doom Tomorrow Night theme for Kitty terminal
      # Adapted from doom-tomorrow-night-theme.el in doom-emacs
      background = "#1d1f21";
      foreground = "#c5c8c6";
      cursor = "#c5c8c6";
      selection_background = "#5c5e5e";

      # Black
      color0 = "#0d0d0d";
      color8 = "#5a5b5a";

      # Red
      color1 = "#cc6666";
      color9 = "#cc6666";

      # Green
      color2 = "#b5bd68";
      color10 = "#b5bd68";

      # Yellow
      color3 = "#f0c674";
      color11 = "#f0c674";

      # Blue
      color4 = "#81a2be";
      color12 = "#81a2be";

      # Magenta
      color5 = "#b294bb";
      color13 = "#b294bb";

      # Cyan
      color6 = "#8abeb7";
      color14 = "#8abeb7";

      # White
      color7 = "#c5c8c6";
      color15 = "#ffffff";

      # Tab bar colors
      active_tab_foreground = "#c5c8c6";
      active_tab_background = "#292b2b";
      inactive_tab_foreground = "#969896";
      inactive_tab_background = "#161719";

      # URL underline color when hovering with mouse
      url_color = "#81a2be";

      # Window border colors (for when you have multiple windows)
      active_border_color = "#81a2be";
      inactive_border_color = "#5a5b5a";

      # Bell border color
      bell_border_color = "#de935f";
    };
  };
}
