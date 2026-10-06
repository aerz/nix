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
        # "abue-ammar/tinycast/tinycast"
        "fif7y/tap/pelmet"
      ];
    };

    # run the following command to add a tap
    # nix-prefetch-github homebrew homebrew-core --nix
    taps = {
      "homebrew/homebrew-core" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-core";
        rev = "52a00718f672785e2927c678d6b73f7405beaabe";
        sha256 = "12p83n0sfy79skwy9rr760a9rbw2ygflc46i7bsqnam34qcdl2l2";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "c114708723e5e67d34f551eb72ed7c2f0e7ae20f";
        sha256 = "0jhxqvdrdxbnbzywbfs1x73c6qm3wayzhnm6fh1vq583kbc8m4cd";
      };
      "fif7y/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "fif7y";
        repo = "homebrew-tap";
        rev = "70194f00ea4a1a5694b8c9d6c381c67fef5beb59";
        sha256 = "0dp32y2ij42lpcdvbjw435gww2jjb6k4n270yglkk3i88grnqykm";
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
        rev = "84a6067ec11e4f6e06101922dcb458f567a0bed7";
        sha256 = "176l6142ps3hhynfcp6ialgagmifskkvnqvhq7fy9jkdl1l78pmh";
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
      # "abue-ammar/tinycast/tinycast"
      "codex"
      "antinote"
      "betterdisplay"
      "bluesnooze"
      "brave-browser"
      "fif7y/tap/pelmet"
      "helium-browser"
      "hyperkey"
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
      "sanesidebuttons"
      "shottr"
      "syncthing-app"
      "zed"
    ];

    masApps = {
      "Gifski" = 1351639930;
      "TickTick" = 966085870;
      "Tailscale" = 1475387142;
      "Pandan" = 1569600264;
      "Pages" = 361309726;
      "Vista" = 6760483098;
      "NordVPN" = 905953485;
      "Numbers" = 361304891;
      "Pixelmator Pro" = 1289583905;
    };
  };
}
