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
        rev = "5f767d4fbf29454f312eb6dfa8adda0622516911";
        sha256 = "0qxizqf2363x465a2ax2cj6f6q96a1ylb6s3gb0c020wj4fy6f7n";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "4750d48455319ae69ea855f20c1a4cefc222f98a";
        sha256 = "01hwv78nfn1a54r8p2g7s05zxhcb6q3lzwk74p6v33fickkzg2w4";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "4fd6e2aa0a5fcd7cac3d19d3aa9b173501b7d8a6";
        sha256 = "17qc658fsm8mrwn8ib8gvjhf9fh5i5brqbi0xd27m3mhn78d68mw";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "134dd4b7904a9559a888aef99a9e1011671e3743";
        sha256 = "1f2cfdlqli62m5bqnc2ncsdn8pnhixafn0alxclizzryfj83r2pk";
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
