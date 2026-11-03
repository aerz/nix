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
        rev = "046433224d7dab924cb05164a4b78aa7292f6f89";
        sha256 = "1r655x7k3ciiccc14hnqzc73cgj75ic4iwca95h1p1c9zwbk774i";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "865544ce7a1491719a453cb7d86da4febd689d29";
        sha256 = "17phb57bh11kpxx83q9l94kjxd1wx3mx2b72x0zmws0lwbym3igc";
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
        rev = "eb95ba5bd1a0ec663b6db134119dfc28cf545633";
        sha256 = "12rclw6d94nkxcsvj35h9qxdlhbfdadhb88xfjacihhwmsjqv9qj";
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
