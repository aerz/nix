{
  config,
  pkgs,
  lib,
  ...
}: let
  default_user_settings = {
    # general
    "workbench.layoutControl.enabled" = false;
    "workbench.navigationControl.enabled" = false;
    "workbench.preferredLightColorTheme" = "GitHub Light";
    "workbench.preferredDarkColorTheme" = "GitHub Dark";
    "window.autoDetectColorScheme" = true;
    "window.zoomLevel" = 1;

    # theme icons
    "workbench.iconTheme" = "symbols";
    "symbols.hidesExplorerArrows" = true;
    "symbols.files.associations" = {
      "justfile" = "robot";
    };

    # window
    "workbench.startupEditor" = "none";
    "workbench.tips.enabled" = false;
    "workbench.activityBar.location" = "hidden";
    "workbench.statusBar.visible" = false;
    "workbench.editor.empty.hint" = "hidden";
    "workbench.sideBar.location" = "right";

    "workbench.editor.showTabs" = "single";
    "window.customTitleBarVisibility" = "never";
    "window.titleBarStyle" = "native";
    "custom-ui-style.electron" = {
      "titleBarStyle" = "hiddenInset";
      "trafficLightPosition" = {
        "x" = 20;
        "y" = 12;
      };
    };
    # use @command:custom-ui-style.reload to apply new changes
    "custom-ui-style.stylesheet" = {
      ".notification-toast" = "box-shadow: none !important";
      ".quick-input-widget.show-file-icons" = "box-shadow: none !important";
      ".quick-input-widget" = "top: 25vh !important";
      ".quick-input-list .scrollbar" = "display: none";
      ".monaco-action-bar.quick-input-inline-action-bar" = "display: none";
      ".editor-widget.find-widget" = "box-shadow: none; border-radius: 4px";
      ".monaco-workbench .part.editor > .content .editor-group-container > .title.title-border-bottom:after" = "display: none";
      ".monaco-scrollable-element > .shadow.top" = "display: none";
      ".sidebar .title-label" = "padding: 0 !important";
      ".sidebar" = "border: none !important";
      ".monaco-workbench .monaco-list:not(.element-focused):focus:before" = "outline: none !important";
      ".monaco-list-row.focused" = "outline: none !important";
      ".monaco-editor .scroll-decoration" = "display: none";
      ".title-actions" = "display: none !important";
      ".title.show-file-icons .label-container .monaco-icon-label.file-icon" = "justify-content: center; padding: 0 !important";
      ".title .monaco-icon-label:after" = "margin-right: 0";
      ".title .monaco-icon-label.file-icon" = "margin: 0 60px";
      ".monaco-workbench .part.editor > .content .editor-group-container > .title > .label-container > .title-label" = "padding-left: 60px";
    };
    "custom-ui-style.font.sansSerif" = "'JetBrainsMono Nerd Font'";

    # scm
    "git.confirmSync" = false;
    "git.autofetch" = false;

    # file explorer
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "workbench.tree.renderIndentGuides" = "none";
    "explorer.decorations.badges" = false;
    "git.decorations.enabled" = false;

    # editor
    "editor.lineHeight" = 1.6;
    "editor.multiCursorModifier" = "ctrlCmd";
    "editor.fontLigatures" = true;
    "editor.formatOnSave" = true;
    "editor.insertSpaces" = true;
    "editor.tabSize" = 2;
    "editor.detectIndentation" = false;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font'";
    "editor.tokenColorCustomizations" = {
      "textMateRules" = [
        {
          "scope" = "comment";
          "settings" = {
            "fontStyle" = "italic";
          };
        }
      ];
    };
    "editor.links" = false;
    "editor.stickyScroll.enabled" = false;
    "editor.minimap.enabled" = false;
    "editor.parameterHints.enabled" = false;
    "editor.lightbulb.enabled" = "off";
    "editor.hover.enabled" = false;
    "scm.diffDecorations" = "none";
    "editor.lineNumbers" = "relative";
    "editor.guides.indentation" = false;
    "editor.renderWhitespace" = "none";
    "editor.renderLineHighlight" = "none";
    "editor.selectionHighlight" = false;
    "editor.showFoldingControls" = "never";
    "editor.linkedEditing" = true;
    "editor.cursorBlinking" = "smooth";
    "editor.bracketPairColorization.enabled" = true;
    "editor.scrollbar.verticalScrollbarSize" = 7;
    "editor.scrollbar.horizontalScrollbarSize" = 7;
    "breadcrumbs.enabled" = false;
    "diffEditor.ignoreTrimWhitespace" = false;
    "files.trimTrailingWhitespace" = true;
    "files.trimFinalNewlines" = true;
    "files.insertFinalNewline" = true;
    "editor.scrollbar.horizontal" = "hidden";
    "editor.scrollbar.vertical" = "hidden";
    "editor.quickSuggestions" = {
      "other" = "off";
    };
    "editor.suggestOnTriggerCharacters" = false;
    "editor.tabCompletion" = "on";
    "editor.snippetSuggetions" = "top";
    "emmet.triggerExpansionOnTab" = true;

    # extensions
    "extensions.showRecommendationsOnlyOnDemand" = true;
    "extensions.ignoreRecommendations" = true;
    "extensions.autoUpdate" = false;
    "extensions.autoCheckUpdates" = false;

    # github copilot
    "chat.commandCenter.enabled" = false;

    # misc
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
  };

  default_extensions = with pkgs.vscode-extensions; [
    github.github-vscode-theme
    miguelsolorio.symbols
    subframe7536.custom-ui-style
  ];
in {
  imports = [
    ../modules/darwin/vscode.nix
  ];

  aerz.vscode = {
    enable = true;

    profiles = {
      default = {
        settings = default_user_settings;
        extensions = default_extensions;
      };

      nix = {
        settings =
          lib.mergeAttrs {
            "[nix]" = {
              "editor.defaultFormatter" = "jnoortheen.nix-ide";
              "editor.semanticHighlighting.enabled" = true;
              "editor.tabSize" = 2;
            };
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";
            "nix.serverSettings" = {
              "nil" = {
                "formatting" = {
                  "command" = ["alejandra"];
                };
              };
            };
          }
          default_user_settings;
        extensions = with pkgs.vscode-extensions;
          [
            nefrob.vscode-just-syntax
            jnoortheen.nix-ide
            vscodevim.vim
            tamasfe.even-better-toml
            yanivmo.navi-cheatsheet-language
            bmalehorn.vscode-fish
          ]
          ++ default_extensions;
      };

      astro = {
        settings =
          lib.mergeAttrs {
            "emmet.triggerExpansionOnTab" = true;
            "emmet.includeLanguages"."javascript" = "javascriptreact";
            "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "typescript.updateImportsOnFileMove.enabled" = "always";
            "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "javascript.updateImportsOnFileMove.enabled" = "always";
            "[mdx]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "rewrap.autoWrap.enabled" = true;
          }
          default_user_settings;
        extensions = with pkgs.vscode-extensions;
          [
            astro-build.astro-vscode
            bradlc.vscode-tailwindcss
            naumovs.color-highlight
            dnut.rewrap-revived
            esbenp.prettier-vscode
            ms-vscode.live-server
            usernamehw.errorlens
            yoavbls.pretty-ts-errors
          ]
          ++ default_extensions;
      };

      typescript = {
        settings =
          lib.mergeAttrs {
            "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "typescript.updateImportsOnFileMove.enabled" = "always";
          }
          default_user_settings;
        extensions = with pkgs.vscode-extensions;
          [
            esbenp.prettier-vscode
            usernamehw.errorlens
            yoavbls.pretty-ts-errors
          ]
          ++ default_extensions;
      };

      ansible = {
        settings =
          lib.mergeAttrs {
            "yaml.customTags" = ["!vault"];
            "[yaml]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "ansible.lightspeed.enabled" = false;
            "ansible.lightspeed.suggestions.enabled" = false;
          }
          default_user_settings;
        extensions = with pkgs.vscode-extensions;
          [
            ms-python.python
            redhat.ansible
            redhat.vscode-yaml
            samuelcolvin.jinjahtml
            esbenp.prettier-vscode
            mkhl.direnv
            jnoortheen.nix-ide
            vorg.vorg
          ]
          ++ default_extensions;
      };
    };
  };

  programs.vscode = {
    enable = false;

    profiles = {
      default = {
        extensions = default_extensions;
        userSettings = default_user_settings;
      };

      nix = {
        extensions = with pkgs.vscode-extensions;
          [
            nefrob.vscode-just-syntax
            jnoortheen.nix-ide
            vscodevim.vim
            tamasfe.even-better-toml
            yanivmo.navi-cheatsheet-language
            bmalehorn.vscode-fish
          ]
          ++ default_extensions;
        userSettings =
          lib.mergeAttrs {
            "[nix]"."editor.tabSize" = 2;
          }
          default_user_settings;
      };

      astro = {
        extensions = with pkgs.vscode-extensions;
          [
            astro-build.astro-vscode
            bradlc.vscode-tailwindcss
            naumovs.color-highlight
            dnut.rewrap-revived
            esbenp.prettier-vscode
            ms-vscode.live-server
            usernamehw.errorlens
            yoavbls.pretty-ts-errors
          ]
          ++ default_extensions;
        userSettings =
          lib.mergeAttrs {
            "emmet.triggerExpansionOnTab" = true;
            "emmet.includeLanguages"."javascript" = "javascriptreact";
            "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "typescript.updateImportsOnFileMove.enabled" = "always";
            "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "javascript.updateImportsOnFileMove.enabled" = "always";
            "[mdx]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "rewrap.autoWrap.enabled" = true;
          }
          default_user_settings;
      };

      typescript = {
        extensions = with pkgs.vscode-extensions;
          [
            esbenp.prettier-vscode
            usernamehw.errorlens
            yoavbls.pretty-ts-errors
          ]
          ++ default_extensions;
        userSettings =
          lib.mergeAttrs {
            "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "typescript.updateImportsOnFileMove.enabled" = "always";
          }
          default_user_settings;
      };

      ansible = {
        extensions = with pkgs.vscode-extensions;
          [
            ms-python.python
            redhat.ansible
            redhat.vscode-yaml
            samuelcolvin.jinjahtml
            esbenp.prettier-vscode
            mkhl.direnv
            jnoortheen.nix-ide
            vorg.vorg
          ]
          ++ default_extensions;
        userSettings =
          lib.mergeAttrs {
            "yaml.customTags" = ["!vault"];
            "[yaml]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "ansible.lightspeed.enabled" = false;
            "ansible.lightspeed.suggestions.enabled" = false;
          }
          default_user_settings;
      };
    };
  };
}
