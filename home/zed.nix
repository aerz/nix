{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) unique fold recursiveUpdate;

  global = {
    extensions = [
      "min-theme"
      "charmed-icons"
    ];

    settings = {
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

  astro = {
    extensions = [
      "html"
      "emmet"
      "astro"
    ];
    settings = {};
  };

  ansible = {
    extensions = ["ansible"];
    settings = {};
  };

  nix = {
    extensions = [
      "nix"
      "fish"
      "toml"
      "just"
      "emmet"
    ];
    settings = {
      # disable language features when no profile active
      languages.Nix = {
        language_servers = [
          "!nil"
          "!nixd"
        ];
      };
      profiles.nix = {
        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
          };
          Fish = {
            formatter.external.command = "fish_indent";
          };
        };
        lsp = {
          nil = {
            initialization_options = {
              formatting.command = [
                "alejandra"
                "--quiet"
                "--"
              ];
              diagnostics = {};
              nix.flake = {
                autoArchive = true;
                autoEvalInputs = true;
              };
            };
          };
        };
      };
    };
  };
in {
  programs.zed-editor = {
    enable = true;
    package = null;
    extensions = unique (
      global.extensions
      ++ astro.extensions
      ++ ansible.extensions
      ++ nix.extensions
    );
    userSettings = fold recursiveUpdate {} [
      global.settings
      astro.settings
      ansible.settings
      nix.settings
    ];
    userKeymaps = [
      {
        bindings = {
          cmd-p = "command_palette::Toggle";
          cmd-f = null;
        };
      }
      # global
      {
        context = "EmptyPane || SharedScreen";
        bindings = {
          # global navigation
          "space space" = "file_finder::Toggle";
          "space f h" = "projects::OpenRecent";
          "space f p" = "zed::OpenSettingsFile";
          "space f k" = "zed::OpenKeymapFile";
          "space f s" = "pane::DeploySearch";
          "space f n" = "workspace::NewFile";
          "space b n" = "workspace::NewFile";
          # dock
          "space e p" = "project_panel::ToggleFocus";
          "space e e" = "workspace::ToggleLeftDock";
          "space e t" = "workspace::ToggleRightDock";
          "space g g" = "git_panel::ToggleFocus";
        };
      }
      {
        context = "Workspace";
        bindings = {
          # close all inactive
          "cmd-w m m" = [
            "action::Sequence"
            ["workspace::CloseAllDocks" "workspace::CloseInactiveTabsAndPanes"]
          ];
        };
      }
      # menu navigation
      {
        context = "Picker > Editor";
        bindings = {
          ctrl-j = "menu::SelectNext";
          ctrl-k = "menu::SelectPrevious";
        };
      }
      {
        context = "Editor && (showing_code_actions || showing_completions)";
        bindings = {
          ctrl-j = "editor::ContextMenuNext";
          ctrl-k = "editor::ContextMenuPrevious";
          tab = "editor::ConfirmCompletionInsert";
        };
      }
      {
        context = "Editor && vim_mode == insert";
        bindings = {
          # escape
          "j k" = "vim::NormalBefore";
          # vim-style completion
          "ctrl-x ctrl-o" = "editor::ShowCompletions";
          # code navigation
          alt-h = "vim::Left";
          alt-l = "vim::Right";
          alt-j = "vim::Down";
          alt-k = "vim::Up";
          alt-J = "editor::MoveLineDown";
          alt-K = "editor::MoveLineUp";
          alt-s = "editor::UnwrapSyntaxNode";
          alt-w = "vim::NextSubwordStart";
          alt-b = "vim::PreviousSubwordStart";
          alt-e = "vim::NextSubwordEnd";
          # force vim-style bindings
          ctrl-space = null;
          cmd-f = null;
        };
      }
      {
        context = "Editor && vim_mode == normal && !VimWaiting && !menu";
        bindings = {
          # global navigation
          "space space" = "file_finder::Toggle";
          "space f h" = "projects::OpenRecent";
          "space f p" = "zed::OpenSettingsFile";
          "space f k" = "zed::OpenKeymapFile";
          "space f s" = "pane::DeploySearch";
          # code
          "g c c" = "editor::ToggleComments";
          shift-k = "editor::Hover";
          # window movement
          ctrl-h = "workspace::ActivatePaneLeft";
          ctrl-l = "workspace::ActivatePaneRight";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-j = "workspace::ActivatePaneDown";
          "space w h" = "workspace::SwapPaneLeft";
          "space w l" = "workspace::SwapPaneRight";
          "space w w" = "workspace::ActivateNextPane";
          "space w z" = "workspace::ToggleZoom";
          # buffers
          "space b B" = "tab_switcher::ToggleAll";
          "space b b" = "tab_switcher::Toggle";
          "space b tab" = "pane::AlternateFile";
          "space b s" = "workspace::Save";
          "space b S" = "workspace::SaveAll";
          "space b n" = "workspace::NewFile";
          "space b k" = "pane::CloseActiveItem";
          "space b d" = "pane::CloseActiveItem";
          "space b f" = "editor::Format";
          shift-h = "pane::ActivatePreviousItem";
          shift-l = "pane::ActivateNextItem";
          # splits
          "space s v" = "pane::SplitRight";
          "space s h" = "pane::SplitDown";
          # panels
          "space e e" = "workspace::ToggleLeftDock";
          "space e t" = "workspace::ToggleRightDock";
          "space e p" = "project_panel::ToggleFocus";
          "space e o" = "outline_panel::ToggleFocus";
          # LSP
          "g ." = "editor::ToggleCodeActions";
          "c d" = "editor::Rename";
          "g d" = "editor::GoToDefinition";
          "g shift-d" = "editor::GoToDefinitionSplit";
          "g s" = "editor::GoToDeclaration";
          "g i" = "editor::GoToImplementation";
          "g shift-i" = "editor::GoToImplementationSplit";
          "g y" = "editor::GoToTypeDefinition";
          "g shift-t" = "editor::GoToTypeDefinitionSplit";
          "g r" = "editor::FindAllReferences";
          # diagnostics
          "space c d" = "diagnostics::Deploy";
          "] d" = "editor::GoToDiagnostic";
          "[ d" = "editor::GoToPreviousDiagnostic";
          # symbols
          "g o" = "outline::Toggle";
          "space c o" = "project_symbols::Toggle";
          # git
          "] h" = "editor::GoToHunk";
          "[ h" = "editor::GoToPreviousHunk";
          "space g h" = "editor::ToggleSelectedDiffHunks";
          "space g S" = "git::ToggleStaged";
          "space g r" = "git::Restore";
          "space g s" = "git::StageAndNext";
          "space g u" = "git::UnstageAndNext";
          "space g U" = [
            "action::Sequence"
            [
              "git::UnstageAndNext"
              "editor::GoToPreviousHunk"
              "editor::GoToPreviousHunk"
            ]
          ];
          "space g b" = "git::Blame";
          "space g d" = "git::Diff";
          "space g c" = "git::Commit";
          "space g g" = "git_panel::ToggleFocus";
        };
      }
      {
        context = "Editor && vim_mode == visual && !menu && !VimWaiting && VimControl";
        bindings = {
          v = "editor::SelectLargerSyntaxNode";
          V = "editor::SelectSmallerSyntaxNode";
          ctrl-s = "vim::PushAddSurrounds";
          shift-x = "vim::Exchange";
        };
      }
      {
        context = "Editor && vim_mode == visual && !VimWaiting && !menu";
        bindings = {
          "g c" = "editor::ToggleComments";
        };
      }
      {
        context = "vim_operator == a || vim_operator == i || vim_operator == cs";
        bindings = {
          q = "vim::AnyQuotes";
          b = "vim::AnyBrackets";
          Q = "vim::MiniQuotes";
          B = "vim::MiniBrackets";
        };
      }
      {
        context = "Editor && vim_operator == c";
        bindings = {
          c = "vim::CurrentLine";
          a = "editor::ToggleCodeActions";
        };
      }
      # vim-sneak
      # https://github.com/zed-industries/zed/pull/22793/files#diff-90c0cb07588e2f309c31f0bb17096728b8f4e0bad71f3152d4d81ca867321c68
      {
        context = "Editor && (vim_mode == normal || vim_mode == visual) && !VimCount";
        bindings = {
          s = "vim::PushSneak";
          shift-s = "vim::PushSneakBackward";
          # go to file
          "g f" = "editor::OpenExcerpts";
        };
      }
      {
        context = "Editor && VimControl && !VimWaiting && !menu && vim_mode != operator";
        bindings = {
          # code navigation
          alt-K = "editor::MoveLineUp";
          alt-J = "editor::MoveLineDown";
          w = "vim::NextSubwordStart";
          b = "vim::PreviousSubwordStart";
          e = "vim::NextSubwordEnd";
          "g e" = "vim::PreviousSubwordEnd";
          # multi-cursor
          cmd-alt-k = "editor::AddSelectionAbove";
          cmd-alt-j = "editor::AddSelectionBelow";
        };
      }
      {
        context = "Editor && (vim_mode == normal || vim_mode == visual) && !VimWaiting && !menu";
        bindings = {
          "space c z" = "workspace::ToggleCenteredLayout";
          "space u w" = "editor::ToggleSoftWrap";
          "space u r" = "vim::Rewrap";
          "space m p" = "markdown::OpenPreview";
          "space m P" = "markdown::OpenPreviewToTheSide";
        };
      }
      {
        context = "Editor";
        bindings = {
          cmd-w = null; # force vim-style bindings
          "ctrl-z a" = "editor::ToggleFoldAll";
        };
      }
      # close zed panels
      {
        context = "ProjectSearchBar || BufferSearchBar ||KeyContextView";
        bindings = {
          ctrl-g = "pane::CloseActiveItem";
        };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          "space e e" = "workspace::ToggleLeftDock";
          "space e t" = "workspace::ToggleRightDock";
          "space g g" = "git_panel::ToggleFocus";
          ctrl-h = "workspace::ActivatePaneLeft";
          ctrl-l = "workspace::ActivatePaneRight";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-j = "workspace::ActivatePaneDown";
          j = "menu::SelectNext";
          k = "menu::SelectPrevious";
          h = "project_panel::CollapseSelectedEntry";
          H = "project_panel::CollapseAllEntries";
          l = "project_panel::ExpandSelectedEntry";
          o = "project_panel::OpenPermanent";
          a = "project_panel::NewFile";
          A = "project_panel::NewDirectory";
          d = "project_panel::Delete";
          r = "project_panel::Rename";
          x = "project_panel::Cut";
          p = "project_panel::Paste";
        };
      }
      {
        context = "GitPanel && ChangesList";
        bindings = {
          shift-p = "project_panel::ToggleFocus";
          shift-e = "workspace::ToggleLeftDock";
        };
      }
      {
        context = "TabSwitcher && !Editor";
        bindings = {
          j = "menu::SelectNext";
          k = "menu::SelectPrevious";
          d = "tab_switcher::CloseSelectedItem";
        };
      }
      {
        context = "Dock";
        bindings = {
          "ctrl-w h" = "workspace::ActivatePaneLeft";
          "ctrl-w l" = "workspace::ActivatePaneRight";
          "ctrl-w k" = "workspace::ActivatePaneUp";
          "ctrl-w j" = "workspace::ActivatePaneDown";
        };
      }
      # Terminal
      {
        context = "Workspace";
        bindings = {
          "ctrl-\\" = "terminal_panel::ToggleFocus";
        };
      }
      {
        context = "Terminal";
        bindings = {
          ctrl-h = "workspace::ActivatePaneLeft";
          ctrl-l = "workspace::ActivatePaneRight";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-j = "workspace::ActivatePaneDown";
        };
      }
    ];
  };
}
