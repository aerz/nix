{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./keymap.nix
    ./astro.nix
    ./ansible.nix
    ./nix.nix
  ];

  programs.zed-editor = {
    enable = true;
    package = null;
    extensions = [
      "min-theme"
      "charmed-icons"
    ];
    userSettings = {
      # theme
      ui_font_size = 16;
      buffer_font_size = 14;
      ui_font_family = "JetBrainsMono Nerd Font";
      buffer_font_family = "JetBrainsMono Nerd Font";
      icon_theme = "Base Charmed Icons";
      theme = {
        mode = "system";
        light = "Min Light (Solid)";
        dark = "Min Dark (Solid)";
      };
      theme_overrides = {
        "Min Dark (Solid)" = {
          background = "#1A1A1A";
          border = "#1A1A1A";
          "border.variant" = "#1A1A1A";
          "title_bar.background" = "#1A1A1A";
          "panel.background" = "#1A1A1A";
          "panel.focused_border" = "#454545";
          "elevated_surface.background" = "#212121";
          syntax = {
            comment = {
              font_style = "italic";
            };
            "comment.doc" = {
              font_style = "italic";
            };
          };
        };
        "Min Light (Solid)" = {
          background = "#FFF";
          border = "#FFF";
          "border.variant" = "#FFF";
          "title_bar.background" = "#FFF";
          "panel.background" = "#FFF";
          "panel.focused_border" = "#D1D1D1";
          "toolbar.background" = "#FFF";
          syntax = {
            comment = {
              font_style = "italic";
            };
            "comment.doc" = {
              font_style = "italic";
            };
          };
        };
      };

      # vim
      vim_mode = true;
      cursor_blink = false;
      scroll_beyond_last_line = "off";
      extend_comment_on_newline = false;
      use_smartcase_search = false;

      # ui
      inline_code_actions = false;
      global_lsp_settings.button = false;
      features.edit_prediction_provider = "none";
      title_bar = {
        show_branch_name = false;
        show_user_picture = false;
        show_user_menu = false;
        show_sign_in = false;
        show_menus = false;
        show_onboarding_banner = false;
        show_project_items = false;
      };
      tab_bar.show = false;
      toolbar.quick_actions = false;
      status_bar."experimental.show" = false;
      which_key = {
        enabled = true;
        delay_ms = 300;
      };
      file_finder = {
        modal_max_width = "large";
      };

      # panels
      project_panel = {
        dock = "right";
        default_width = 400;
        indent_size = 8.0;
        indent_guides.show = "never";
        scrollbar.show = "never";
        sticky_scroll = false;
        hide_root = true;
        starts_open = false;
      };
      outline_panel = {
        dock = "right";
        default_width = 300;
        indent_size = 8.0;
        indent_guides.show = "never";
      };
      terminal = {
        toolbar.breadcrumbs = false;
        default_height = 480;
        env = {
          EDITOR = "zed -w";
          VISUAL = "zed -w";
          GIT_EDITOR = "zed --wait";
        };
      };
      collaboration_panel.dock = "left";
      notification_panel.dock = "left";
      chat_panel.dock = "left";

      # editor
      remove_trailing_whitespace_on_save = true;
      indent_guides.enabled = false;
      relative_line_numbers = "enabled";
      show_whitespaces = "selection";
      current_line_highlight = "none";
      show_completions_on_input = false;
      colorize_brackets = true;
      scrollbar.show = "never";
      tab_size = 2;
      gutter = {
        folds = false;
      };
      git = {
        inline_blame.enabled = false;
      };
      diagnostics = {
        inline = {
          enabled = true;
          max_severity = "error";
        };
      };
      inlay_hints.enabled = true;
      sticky_scroll.enabled = true;

      # direnv
      load_direnv = "shell_hook";

      # misc
      auto_update = false;
      telemetry = {
        diagnostics = true;
        metrics = true;
      };
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        "**/out"
        "**/dist"
        "**/.husky"
        "**/.turbo"
        "**/.vscode-test"
        "**/.vscode"
        "**/.next"
        "**/.storybook"
        "**/.tap"
        "**/.nyc_output"
        "**/report"
        "**/node_modules"
      ];
    };
  };
}
