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

    # run the following command to add a tap
    # nix-prefetch-github homebrew homebrew-core --nix
    taps = {
      "homebrew/homebrew-core" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-core";
        rev = "6d4da7da8c6b2071589703dc97eb872b1e0d8479";
        sha256 = "0cwd0wknavg3xpnnblvykks81aldbamfblqnzf2mw9wl9r97iss8";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "6ea6f8c29c1aa600a54b528be27b6fe08fd116ff";
        sha256 = "1h3iz2gd1a8wzripqnq1s05bj3rf147b2lsnmf9sgkasn25kqiwz";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "c7d545cb5097cb625442a159326687683ffe04ce";
        sha256 = "12z61ancjfyck9xq8wg2pqr4nj3cjiczl101cfdj9qs1mc5dkj5v";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "46c0391acf5e28c730b1aa35ecab31224ef860fa";
        sha256 = "1ppkfpaisz8m06kz8v3ziiljmgbrqhvv7z5s5m7787zgmmc85ss5";
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
      extraEnv = {
        # https://github.com/zhaofengli/nix-homebrew/issues/156
        HOMEBREW_NO_REQUIRE_TAP_TRUST = "1";
      };
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      "blueutil"
      "bitwarden-cli"
      "git"
      "pandoc"
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
