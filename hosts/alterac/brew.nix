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
        rev = "8d72e48ef9a27ddc64b5dadc48d6006f2dec555e";
        sha256 = "0c50xb556gmwm3c0nlc445c852mgdghc5hkq2bh7gyn7hidmbldq";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "64030ce7ea2e5f30699107a7ef7c4504658416a0";
        sha256 = "04jf2jqf6x9qxrsg0ms102wnfl5br7i5rg7gap3rc0p1gw4nz4a7";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "2c286eb9092e8fc90ab81dd4d20bd90bec5f7ab9";
        sha256 = "148i7gb4nyq4g1l1w42kiymkzxc1vp8s5z6l007awd7x3hxgvw6b";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "7ff15f39f0849eeaf7e7822f225dc2a3310431f7";
        sha256 = "03yiw4s43vafn3a27p6imh8prxijw161qvjmxaa597cvsvnn3z89";
      };
      "d12frosted/homebrew-emacs-plus" = pkgs.fetchFromGitHub {
        owner = "d12frosted";
        repo = "homebrew-emacs-plus";
        rev = "343bf9d50af9027f15dbd2c89396b09f192cf00b";
        sha256 = "19rbsaayagw6a0kzw8fxgx43f6havsv8fb9j2nbgpm11crhjgzdr";
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
      "emacs-plus-app"
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
