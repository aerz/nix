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
      # homebrew-core and homebrew-cask are not pinned here
      # since homebrew 4.0 formulas resolve via JSON API not local git clone
      # pinning core re-enables legacy code path which overrides third-party
      # taps on upgrade
      # "homebrew/homebrew-core" = ...;
      # "homebrew/homebrew-cask" = ...;
      "homebrew/homebrew-core" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-core";
        rev = "dffcea4fd1ae42c1ae68b3ef15ab19db0a812860";
        hash = "sha256-PYJyYPRNZTEAxRi1Crp+rC/DmWU2d+KLLwj2/dZt+bA=";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "9fb45dc031e8d0b51cc1099212d2db83029df353";
        hash = "sha256-NjoWFCmosYFnoZpd8RszCnBHh3ICvVCFE08GWKONspA=";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "bf20a2fa72c7eda259d9e09b03fd674498caffa9";
        hash = "sha256-dgx6mzM0IAIsqwDPOl1nB53qO5Ru41nhWEg7068OXso=";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "e34f6e6201122bf1a774db83f92465ddfce9624c";
        hash = "sha256-EnDwKzDHGRm2YWmmEZHg+xy8VD1csuYsvDEMnDV2zFY==";
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
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      "blueutil"
      "bitwarden-cli"
      "git"
      "pandoc"
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
      "numi"
      "raycast"
      "sanesidebuttons"
      "shottr"
      "syncthing-app"
      "zed"
    ];
  };
}
