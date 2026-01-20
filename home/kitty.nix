{
  config,
  pkgs,
  lib,
  ...
}: let
  kitty_settings = {
    # window layout
    inactive_text_alpha = 0.7;
    window_padding_width = 5;
    window_border_width = "0px";
    enabled_layouts = "splits";

    # scrollback (history)
    scrollback_lines = 5000;
    scrollback_pager = "less --chop-long-lines --raw-control-chars +INPUT_LINE_NUMBER";

    # fonts
    disable_ligatures = "cursor";

    # tab bar
    tab_bar_edge = "bottom";
    tab_bar_style = "fade";
    tab_fade = 0;
    tab_bar_margin_width = 0;
    tab_bar_margin_height = "5 0";

    # macos
    macos_show_window_title_in = "none";
    hide_window_decorations = "titlebar-only";
    macos_colorspace = "displayp3";
    macos_option_as_alt = "left";
    macos_titlebar_color = "background";

    # misc
    notify_on_cmd_finish = "unfocused";
    enable_audio_bell = "no";
    update_check_interval = 0;
  };

  kitty_extra_config = builtins.concatStringsSep "\n" [
    "mouse_map left click ungrabbed"
    "mouse_map ctrl+left press ungrabbed,grabbed mouse_click_url"
  ];

  kitty_bindings = {
    # default shortcuts
    # https://gist.github.com/AskinNet/0d0d4f7f0ee221f8362af9d9876d021a
    "cmd+t" = "new_tab";
    "cmd+w" = "close_window";
    "cmd+shift+n" = "new_os_window";

    "cmd+d" = "launch --location=hsplit --cwd=current";
    "cmd+shift+d" = "launch --location=vsplit --cwd=current";
    "cmd+k" = "next_window";
    "cmd+j" = "previous_window";

    "cmd+1" = "goto_tab 1";
    "cmd+2" = "goto_tab 2";
    "cmd+3" = "goto_tab 3";
    "cmd+4" = "goto_tab 4";
    "cmd+5" = "goto_tab 5";

    "cmd+shift+k" = "scroll_page_up";
    "cmd+shift+j" = "scroll_page_down";

    "cmd+plus" = "change_font_size all +2.0";
    "cmd+minus" = "change_font_size all -2.0";
    "cmd+0" = "change_font_size all 0";

    "cmd+c" = "copy_to_clipboard";
    "cmd+v" = "paste_from_clipboard";
  };

  kitty_doom_tomorrow_night_theme = {
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
    # https://github.com/kovidgoyal/kitty/discussions/3984#discussioncomment-1300900
    tab_title_template = "{fmt.bg.default}{fmt.fg._5a5b5a} {title} {fmt.fg.default}";
    active_tab_title_template = "{fmt.bg.default}{fmt.fg._c6c6c6} {title} {fmt.fg.default}";

    # URL underline color when hovering with mouse
    url_color = "#81a2be";

    # Window border colors (for when you have multiple windows)
    active_border_color = "#81a2be";
    inactive_border_color = "#5a5b5a";

    # Bell border color
    bell_border_color = "#de935f";
  };
in {
  programs.kitty = {
    enable = true;
    package = null;
    shellIntegration.enableZshIntegration = true;
    shellIntegration.enableFishIntegration = true;
    font.name = "JetBrainsMono Nerd Font Mono";
    font.size = 15;
    keybindings = kitty_bindings;
    settings = lib.mergeAttrs kitty_doom_tomorrow_night_theme kitty_settings;
    extraConfig = kitty_extra_config;
  };
}
