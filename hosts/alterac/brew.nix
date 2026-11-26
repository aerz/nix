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
        rev = "a94892bb1cf94912a843388df742cb236188ace2";
        sha256 = "1czasfm593zhm230lm934acjb792xmhj7cf8qw5pxb9i36c2c1f6";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "0c6dce3e499deb37b57859e0944e742eddfcf869";
        sha256 = "0r5mhx4jnwnsxg18hk5pz5w7wi899kdqgdqbk744gbqd3k6f2627";
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
        rev = "4c200d4f961386f80f65eb0985a00621eed4eb7c";
        sha256 = "0vf5k4br670frj85s5p2aj3nxw9favfyahvky4c8fvn5n1qfnfn7";
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
        rev = "582e67321558cfab76f1813db3fbf96880659d12";
        sha256 = "04152fw9iyfqvqd3qaaln6znpp5sbzlbbqcp1z9mjqgdsgypykgf";
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
