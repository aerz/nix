{...}: {
  programs.zed-editor.userKeymaps = [
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
        r = "editor::Rename";
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
}
