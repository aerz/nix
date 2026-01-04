{
  config,
  pkgs,
  lib,
  ...
}:
let
  default_user_settings = {
    "workbench.layoutControl.enabled" = false;
    "workbench.navigationControl.enabled" = false;
    "workbench.preferredLightColorTheme" = "GitHub Light";
    "workbench.preferredDarkColorTheme" = "GitHub Dark";
    "workbench.iconTheme" = "symbols";
    "symbols.files.associations" = {
      "justfile" = "robot";
    };
    "workbench.startupEditor" = "none";
    "workbench.activityBar.location" = "hidden";
    "workbench.editor.showTabs" = "none";
    "workbench.statusBar.visible" = false;
    "workbench.editor.empty.hint" = "hidden";

    "git.confirmSync" = false;
    "git.autofetch" = false;

    "window.zoomLevel" = 1;
    "window.autoDetectColorScheme" = true;
    "chat.commandCenter.enabled" = false;

    "diffEditor.ignoreTrimWhitespace" = false;

    "files.trimTrailingWhitespace" = true;
    "files.trimFinalNewlines" = true;
    "files.insertFinalNewline" = true;

    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;

    "editor.fontLigatures" = true;
    "editor.formatOnSave" = true;
    "editor.insertSpaces" = true;
    "editor.tabSize" = 2;
    "editor.rulers" = [
      80
      120
    ];
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
    "editor.minimap.enabled" = false;
    "editor.lineNumbers" = "relative";
    "editor.linkedEditing" = true;
    "editor.cursorBlinking" = "smooth";
    "editor.bracketPairColorization.enabled" = true;
    "editor.scrollbar.verticalScrollbarSize" = 7;
    "editor.scrollbar.horizontalScrollbarSize" = 7;
    "breadcrumbs.enabled" = false;

    "extensions.showRecommendationsOnlyOnDemand" = true;
    "extensions.ignoreRecommendations" = true;
    "extensions.autoUpdate" = false;

    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
  };

  default_extensions = with pkgs.vscode-extensions; [
    github.github-vscode-theme
    alefragnani.project-manager
    chadalen.vscode-jetbrains-icon-theme
    miguelsolorio.symbols
  ];
in
{
  programs.vscode = {
    enable = true;

    profiles = {
      default = {
        extensions = default_extensions;
        userSettings = default_user_settings;
      };

      nix = {
        extensions =
          with pkgs.vscode-extensions;
          [
            nefrob.vscode-just-syntax
            jnoortheen.nix-ide
            vscodevim.vim
            tamasfe.even-better-toml
            yanivmo.navi-cheatsheet-language
            bmalehorn.vscode-fish
          ]
          ++ default_extensions;

        userSettings = lib.mergeAttrs {
          "[nix]"."editor.tabSize" = 2;
        } default_user_settings;
      };

      astro = {
        extensions =
          with pkgs.vscode-extensions;
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

        userSettings = lib.mergeAttrs {
          "emmet.triggerExpansionOnTab" = true;
          "emmet.includeLanguages"."javascript" = "javascriptreact";
          "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "[mdx]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "rewrap.autoWrap.enabled" = true;
        } default_user_settings;
      };

      ansible = {
        extensions =
          with pkgs.vscode-extensions;
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

        userSettings = lib.mergeAttrs {
          "yaml.customTags" = [ "!vault" ];
          "[yaml]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "ansible.lightspeed.enabled" = false;
          "ansible.lightspeed.suggestions.enabled" = false;
        } default_user_settings;
      };
    };
  };
}
