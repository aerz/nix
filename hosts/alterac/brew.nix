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
        rev = "907454ea24f451d2a462f6c364099277a553b866";
        sha256 = "13rrldn4pbwgskz4qp2lc6zdmak8222kd8r73in9aym9dvisi0z5";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "f5bbf0c10c7ca19568f0b4422352990b1c6dfdef";
        sha256 = "0nyb9sj9cigg6lf06q4mmj90lznfzv1nf1nwchsmmqwm443jhzfw";
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
        rev = "99c8fa1b4fb4a47b17e3e976794602e809d42b38";
        sha256 = "155i1azcwcnam2vm4r8kjnsw5i43qv50b7s0lhlk2y33f8dmzik2";
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
