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
        rev = "140bc06d05fc20b321b6746d426130c9c890d80d";
        sha256 = "1xn1dydw3yjvmdank833lriqvg628wgn0r56fzbi7my12fnllsx4";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "35ead4cc213dc17bf7aca789b7593a4590be3f5f";
        sha256 = "0bv40ngsgr2b2c14x3zn8lr97518sjh8npim855w02ypnis2bvx3";
      };
      "aerz/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "aerz";
        repo = "homebrew-tap";
        rev = "f272f531a4a2992a0cfd2fa23ac89cc6ce1a1ee8";
        sha256 = "1j11l7imc67gpdfzjqkhnzwp2qvagp3lz8a7q1p8kxwdic5ffrjr";
      };
      "fif7y/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "fif7y";
        repo = "homebrew-tap";
        rev = "27d213cd85b74faeceafdc35ab5bd3e66110a291";
        sha256 = "1wllaz3018cjklkgqlmklc32r7sfhpgls9mly44sxwqq1jgqss2y";
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
        rev = "829902d45835c4501b5da4df091511c386c52661";
        sha256 = "0gbgp9ynqf65hn7nh1d48inhb9sw698pi54nqaj0cv88fbanlayg";
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
      "shichizip-zs"
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
      "Xcode" = 497799835;
    };
  };
}
