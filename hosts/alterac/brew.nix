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
        rev = "558f0c3ad2d52e41e22ed7b4e17069d0db05d8ea";
        sha256 = "10280vb1a9vwx4bwixfmwndv3nfwc9r6ym456yjld7qpxqvxqzra";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "eeda62fa0072814c0e89622e7bbd943b8478824b";
        sha256 = "1b2fphikidp39mcdzp7zjkcj4n2q0r88p40hkshm8p5p6v71qksw";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "9be4ee659951f78eb947fb6578837f0ae3d5953b";
        sha256 = "044qgri67sv9syzxavmaikl7x32ks158dwpc37j7bdqljiwxl6f1";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "e32615163ceaf6c9a04081c878e9b51eb486f78e";
        sha256 = "05p21j0cxm3qs0jp3m8wkpwjplcqhq7n62yv5b66dwsyanmnsi1h";
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
