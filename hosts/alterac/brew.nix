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
        "anomalyco/tap/opencode-v2"
      ];
      casks = [
        # "abue-ammar/tinycast/tinycast"
        "aerz/tap/kaygan"
        "fif7y/tap/dimble"
      ];
    };

    # run the following command to add a tap
    # nix-prefetch-github homebrew homebrew-core --nix
    taps = {
      "homebrew/homebrew-core" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-core";
        rev = "a05a5f423ceda196a7adc045b966afcf94d7d2d9";
        sha256 = "1v8sdja9vbla20zx564y18s7nm9x7pp4c8x8li1gmzflqv5yl1mm";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "a750e78d9308b59fd10bb0eef697a0c2154b7e27";
        sha256 = "0wk1gxiq13a0qgp721i50syc1z90a05c0pcizvlw6dsj4szq3553";
      };
      "aerz/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "aerz";
        repo = "homebrew-tap";
        rev = "3e4824c12760129053cd797824587eda36e44c08";
        sha256 = "1ffd7pnyvd9albn7lzwbjz1cxmhfil787szwdzxylcf83mxa894b";
      };
      "fif7y/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "fif7y";
        repo = "homebrew-tap";
        rev = "61013a83e9e91b10119f5d589a2cb8aabeaa05c5";
        sha256 = "0zjgvhr75x2ijqpy4phg5vf6b72xw4209rpw2nqbll46wq9yyh6i";
      };
      # "abue-ammar/homebrew-tinycast" = pkgs.fetchFromGitHub {
      #   owner = "abue-ammar";
      #   repo = "homebrew-tinycast";
      #   rev = "77318c3a2350675256c28a2cf3f63f6c884c2c98";
      #   sha256 = "03a8iamihmf5g1pn7qg1ahircn9saxlnajcs2jfx2pg4gimipsrr";
      # };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "50e25ffbb532b9b1ed37a3f0c6099a74048ddc39";
        sha256 = "127l9bcqmicr696ym22gf7zaixmsm85n44mbr0kcr3pyplyzc5v1";
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
      "mole"
      "anomalyco/tap/opencode-v2"
      "xcode-build-server"
      "xcodegen"
    ];

    casks = [
      # "abue-ammar/tinycast/tinycast"
      "codex"
      "antinote"
      "aerz/tap/kaygan"
      "betterdisplay"
      "bluesnooze"
      "brave-browser"
      "fif7y/tap/dimble"
      "helium-browser"
      "imageoptim"
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
      "numi"
      "raycast"
      "shichizip-zs"
      "shottr"
      "syncthing-app"
      "zed"
    ];

    masApps = {
      "Gifski" = 1351639930;
      "Tailscale" = 1475387142;
      "Pandan" = 1569600264;
      "Pages" = 361309726;
      "Vista" = 6760483098;
      "NordVPN" = 905953485;
      "Numbers" = 361304891;
      "Pixelmator Pro" = 1289583905;
      "Xcode" = 497799835;
    };
  };
}
