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

    # propagate user config path into Homebrew activation environment
    extraEnv = {
      XDG_CONFIG_HOME = config.home-manager.users.aerz.xdg.configHome;
    };

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
        rev = "569a9196eb72a2b42c58a9297d87fbdc6d4746c8";
        sha256 = "0vz0cixc0m10j74k9czv2sgxci81slnc7n0g116gl6k971fpw9mb";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "b168102a57e7dae8ddc32b2b3dfb2fef340e13b1";
        sha256 = "1zdpdpvjqsfin9awk9zqxfbz4jhbk1qxq23zwn2y1a1vc3b5fi5g";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "2c1daa33bde61008f29e771ac97d9113ae2e6bfb";
        sha256 = "0qw0a4jzrf0a9vdiszp31kg8svl2a186k7cgbsl270y07cmdyhdj";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "538725f116c1111d4abd176b8383bd856c4af182";
        sha256 = "0rw7j6xrb48sb9nc8fza55wf2hvawzrn26yz7gfacpw3f5d4i5r7";
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
