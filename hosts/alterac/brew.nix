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
        "anomalyco/homebrew-tap/opencode"
      ];
    };

    # run the following command to add a tap
    # nix-prefetch-github homebrew homebrew-core --nix
    taps = {
      "homebrew/homebrew-core" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-core";
        rev = "a602960faf79940944b2fb8c0e516fe76d362e43";
        sha256 = "10h1jyplk9c1g10mljfvkzvxjgyx2sjd7q7vav1az13w49iw9z6s";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "af2e9d7e961bfc9d61771f69c56f69037921078c";
        sha256 = "1iw8c25xg49lyvj6gs45d3gix5yhqvaim3qgm2f53206grhy0ia9";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "db49a4d9a3c05d34645baabc907d00d9d2b495f4";
        sha256 = "1k9nsplxf40igj9rndqwldkdzb7027jr89xfgy9xh1j7lwdlrab8";
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

    masApps = {
      "TickTick" = 966085870;
      "Tailscale" = 1475387142;
      "Pandan" = 1569600264;
      "Pages" = 361309726;
      "NordVPN" = 905953485;
      "Numbers" = 361304891;
      "Pixelmator Pro" = 1289583905;
    };
  };
}
