{
  config,
  pkgs,
  lib,
  ...
}: {
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
        alt-shift-f = "fullscreen";
        alt-shift-c = "exec-and-forget ${config.xdg.configHome}/aerospace/center-floating.swift";
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
        c = ["layout floating" "exec-and-forget ${config.xdg.configHome}/aerospace/center-floating.swift" "mode main"];
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
        c = "exec-and-forget ${config.xdg.configHome}/aerospace/center-floating.swift";
        shift-h = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh -50 0";
        shift-j = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh 0 -50";
        shift-k = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh 0 50";
        shift-l = "exec-and-forget ${config.xdg.configHome}/aerospace/resize-floating.sh 50 0";
      };
      on-window-detected = [
        {
          "if".app-id = "com.apple.finder";
          run = "layout floating";
        }
        {
          "if".app-id = "com.apple.ActivityMonitor";
          run = "layout floating";
        }
        {
          "if".app-id = "com.apple.AppStore";
          run = "layout floating";
        }
        {
          "if".app-id = "com.apple.keychainaccess";
          run = "layout floating";
        }
        {
          "if".app-id = "com.apple.weather";
          run = "layout floating";
        }
        {
          "if".app-id = "com.tdesktop.Telegram";
          run = "layout floating";
        }
        {
          "if".app-id = "org.localsend.localsendApp";
          run = "layout floating";
        }
      ];
    };
  };

  xdg.configFile."aerospace/center-floating.swift" = {
    source = ./center-floating.swift;
  };
  xdg.configFile."aerospace/resize-floating.sh" = {
    source = ./resize-floating.sh;
  };
}
