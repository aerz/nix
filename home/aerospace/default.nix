{
  config,
  pkgs,
  lib,
  ...
}: let
  aerospace-scripts = pkgs.stdenv.mkDerivation {
    pname = "aerospace-scripts";
    version = "1.0.0";
    src = builtins.path {
      path = ./scripts;
      name = "aerospace-scripts";
    };
    dontUnpack = true;
    nativeBuildInputs = [pkgs.swift];
    buildPhase = ''
      swiftc -O "$src/center-floating.swift" -o center-floating
      swiftc -O "$src/resize-floating.swift" -o resize-floating
    '';
    installPhase = ''
      install -Dm755 center-floating "$out/bin/center-floating"
      install -Dm755 resize-floating "$out/bin/resize-floating"
    '';
  };
in {
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      config-version = 2;
      start-at-login = false;
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      automatically-unhide-macos-hidden-apps = false;
      persistent-workspaces = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "9"
        "0"
      ];
      workspace-to-monitor-force-assignment = {
        "9" = "secondary";
        "0" = "secondary";
      };
      on-mode-changed = [];
      key-mapping = {
        preset = "qwerty";
      };
      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer.left = 0;
        outer.bottom = 0;
        outer.top = 0;
        outer.right = 0;
      };
      mode.main.binding = {
        # layout
        alt-shift-f = "layout floating tiling";
        alt-shift-enter = "fullscreen";
        alt-shift-c = "exec-and-forget ${config.xdg.configHome}/aerospace/center-floating.sh";
        alt-shift-slash = "layout tiles horizontal vertical";
        alt-shift-comma = "layout accordion horizontal vertical";
        # focus
        alt-shift-h = "focus left";
        alt-shift-j = "focus down";
        alt-shift-k = "focus up";
        alt-shift-l = "focus right";
        # move
        alt-ctrl-h = "move left";
        alt-ctrl-j = "move down";
        alt-ctrl-k = "move up";
        alt-ctrl-l = "move right";
        # workspace
        alt-ctrl-1 = "workspace 1";
        alt-ctrl-2 = "workspace 2";
        alt-ctrl-3 = "workspace 3";
        alt-ctrl-4 = "workspace 4";
        alt-ctrl-5 = "workspace 5";
        alt-ctrl-6 = "workspace 6";
        alt-ctrl-9 = "workspace 9";
        alt-ctrl-0 = "workspace 0";
        # move node to workspace
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 0";
        # workspace
        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
        # mode
        alt-shift-semicolon = "mode service";
        alt-shift-r = "mode resize";
        alt-shift-period = "mode floating";
      };
      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"];
        f = ["layout floating tiling" "mode main"];
        c = ["layout floating" "exec-and-forget ${config.xdg.configHome}/aerospace/center-floating.sh" "mode main"];
        backspace = ["close-all-windows-but-current" "mode main"];
        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];
      };
      mode.resize.binding = {
        esc = ["reload-config" "mode main"];
        minus = "resize smart -50";
        equal = "resize smart +50";
        shift-equal = "balance-sizes";
      };
      mode.floating.binding = {
        esc = ["mode main"];
        f = ["layout tiling" "mode main"];
        c = "exec-and-forget ${config.xdg.configHome}/aerospace/center-floating.sh";
        equal = "exec-and-forget open -g raycast://extensions/raycast/window-management/reasonable-size";
        alt-l = ["exec-and-forget open -g raycast://extensions/raycast/window-management/last-third" "mode main"];
        alt-h = ["exec-and-forget open -g raycast://extensions/raycast/window-management/first-third" "mode main"];
        shift-h = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh -50 0";
        shift-j = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh 0 -50";
        shift-k = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh 0 50";
        shift-l = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh 50 0";
      };
      on-window-detected =
        []
        ++ (
          lib.map (x: {
            "if".app-id = x;
            run = "layout floating";
          }) [
            "com.apple.finder"
            "com.apple.ActivityMonitor"
            "com.apple.AppStore"
            "com.apple.keychainaccess"
            "com.apple.weather"
            "com.tdesktop.Telegram"
            "org.localsend.localsendApp"
            "cc.ffitch.shottr"
          ]
        );
    };
  };
  xdg.configFile."aerospace/center-floating.sh" = {
    text = ''
      #!/usr/bin/env bash

      ${lib.getExe' aerospace-scripts "center-floating"} && \
        open -g raycast://script-commands/toast?arguments=Floating%20window%20centered
    '';
    executable = true;
  };
  xdg.configFile."aerospace/resize-floating.sh" = {
    text = ''
      #!/usr/bin/env bash

      ${lib.getExe' aerospace-scripts "resize-floating"} "$1" "$2" && \
        open -g raycast://script-commands/toast?arguments=Floating%20window%20resized
    '';
    executable = true;
  };
}
