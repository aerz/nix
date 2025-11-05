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
    "workbench.preferredDarkColorTheme" = "GitHub Dark Default";
    "workbench.iconTheme" = "vscode-jetbrains-icon-theme-2023-auto";
    "workbench.startupEditor" = "none";
    "workbench.activityBar.location" = "hidden";
    "workbench.editor.showTabs" = "none";
    "workbench.statusBar.visible" = false;
    "workbench.editor.empty.hint" = "hidden";

    "git.confirmSync" = false;

    "window.zoomLevel" = 1;
    "window.autoDetectColorScheme" = true;

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
    "editor.cursorBlinking" = "smooth";

    "extensions.showRecommendationsOnlyOnDemand" = true;
    "extensions.ignoreRecommendations" = true;
    "extensions.autoUpdate" = false;

    "diffEditor.ignoreTrimWhitespace" = false;

    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
  };

  chadalen.vscode-jetbrains-icon-theme = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-jetbrains-icon-theme";
      publisher = "chadalen";
      version = "2.36.0";
      hash = "sha256-p5hqytkF5Hg2d9N+XwZ5DfG2GEfoSPYXX0FCeUUR2Yc=";
    };
  };
  yanivmo.navi-cheatsheet-language = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "navi-cheatsheet-language";
      publisher = "yanivmo";
      version = "1.0.1";
      hash = "sha256-xnFnX3sa5kblw+kIoJ5CkrZUHDKaxxjzdn361eY0dKE=";
    };
  };
  dnut.rewrap-revived = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "rewrap-revived";
      publisher = "dnut";
      version = "17.9.0";
      hash = "sha256-au71N3gVDMKnTX9TXzGt9q4b3OM7s8gMHXBnIVZ/1CE=";
    };
  };

  default_extensions = with pkgs.vscode-extensions; [
    github.github-vscode-theme
    alefragnani.project-manager
    chadalen.vscode-jetbrains-icon-theme
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
            dnut.rewrap-revived
            esbenp.prettier-vscode
            ms-vscode.live-server
            usernamehw.errorlens
          ]
          ++ default_extensions;

        userSettings = lib.mergeAttrs {
          "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "[mdx]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "rewrap.autoWrap.enabled" = true;
        } default_user_settings;
      };

    };
  };
}
