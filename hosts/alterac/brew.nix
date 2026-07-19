{
  config,
  pkgs,
  ...
}: {
  nix-homebrew = {
    enable = true;
    autoMigrate = true;
    mutableTaps = false;
    enableRosetta = false;
    user = "aerz";

    trust = {
      formulae = [
        "tw93/homebrew-tap/mole"
        "anomalyco/homebrew-tap/opencode"
      ];
    };

    # run the following command to add a tap
    # nix-prefetch-github homebrew homebrew-core --nix
    taps = {
      "homebrew/homebrew-core" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-core";
        rev = "58b69f3eeaed23e4d947cb6c2844d4e173c65a38";
        sha256 = "0f9r6xv7rr4kska1ymf9vx5jicgcbj4jbxmk1l2dxasxwgxi9lg5";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "cef5f3b91a23e97e72e62fa6e1435d7cbd356477";
        sha256 = "1qld3khqpk2rljzsr87rzfg51a263zrnfby3x8zyrw1gnslm3gkn";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "1a2e7726ad9c119f9569d86f1060c55a53ff5109";
        sha256 = "1fy13yadb636qfrp04i3agng8d39f5mx1z3v41ngc2ydz07l3409";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "90be779029819f00f55f9ab79d5b5979d348a5a3";
        sha256 = "1b72bcydmpzkr9a5njzsnia9k9igkprj604m1nfsalm6yn7immmf";
      };
    };
  };

  homebrew = {
    enable = true;

    global.autoUpdate = false;
    greedyCasks = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
      extraEnv = {};
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      "blueutil"
      "bitwarden-cli"
      "git"
      "pandoc"
      "pake"
      "rtk"
      "tw93/tap/mole"
      "anomalyco/tap/opencode"
    ];

    casks = [
      "codex"
      "antinote"
      "betterdisplay"
      "bluesnooze"
      "brave-browser"
      "helium-browser"
      "hyperkey"
      "imageoptim"
      "jordanbaird-ice"
      "telegram-desktop"
      "localsend"
      "iina"
      "zen"
      "spotify"
      "pearcleaner"
      "notunes"
      "obsidian"
      "visual-studio-code"
      "keka"
      "keepassxc"
      "keyboardcleantool"
      "kitty"
      "lm-studio"
      "numi"
      "raycast"
      "sanesidebuttons"
      "shottr"
      "syncthing-app"
      "zed"
    ];
  };
}
