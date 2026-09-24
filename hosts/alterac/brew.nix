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
        rev = "1a5b91573501be449a7d9217fc3683dc94877a0c";
        sha256 = "0i2wq9difc53liknkp45mbk2pmsinvyh8r0ydyy56qd1fb4mg2vn";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "90466fe05258b49155bd4640014aa4a6404a8040";
        sha256 = "0h8h3qw2z0j3lr5ipc2xmjxlnjz73a15f6x50y7s3gpmnnkl88xz";
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
        rev = "c2b38e2864304481248be0dd7072abfb3974e170";
        sha256 = "0fz793cm3g1hkjlyy1adgql73nmin2mjsfc8mbdq3lnrww1b9jc0";
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
