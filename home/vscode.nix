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
    "workbench.startupEditor" = "none";
    "workbench.activityBar.location" = "hidden";
    "workbench.editor.showTabs" = "none";
    "workbench.statusBar.visible" = false;

    "git.confirmSync" = false;

    "window.zoomLevel" = 1;
    "window.autoDetectColorScheme" = true;

    "files.trimTrailingWhitespace" = true;
    "files.trimFinalNewlines" = true;
    "files.insertFinalNewline" = true;

    "editor.fontLigatures" = true;
    "editor.formatOnSave" = true;
    "editor.rulers" = [
      80
      120
    ];
    "editor.minimap.enabled" = false;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";

    "diffEditor.ignoreTrimWhitespace" = false;

    "telemetry.telemetryLevel" = "off";
  };

  default_extensions = with pkgs.vscode-extensions; [
    github.github-vscode-theme
  ];
in
{
  programs.vscode = {
    enable = true;

    extensions = default_extensions;
    userSettings = default_user_settings;

    profiles.nix = {
      extensions =
        with pkgs.vscode-extensions;
        [
          nefrob.vscode-just-syntax
          jnoortheen.nix-ide
          vscodevim.vim
        ]
        ++ default_extensions;

      userSettings = lib.mergeAttrs {
        "[nix]"."editor.tabSize" = 2;
      } default_user_settings;
    };
  };
}
