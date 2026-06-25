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
        rev = "7dea0b54ef1bf642ff3597d8051e4ec4b9232264";
        sha256 = "10abdj5asniwb5ksz585i6np4zv9a1mm6gvgwsv35xzkj9agrgb7";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "76012aa82ca840e9ae8905de0e2c9e661cf4eb72";
        sha256 = "0kb1sl72ck3fkdaladzibcc9svygy8v58az82zx653z2mmmcr4wv";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "dc9a3eeef4e30027cb9ab841e31dc92bb2df9fdf";
        sha256 = "1i9khpml7s6nkp7xwhhz6q5y8gkn7yirjnba4qr3q4ki8la3wqcj";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "d0a3f58d85b4c8966c03aeff97afdb3fa47df7ba";
        sha256 = "1n299ipgnqz6h2xjk72183dlv98r3v5ak057iaa1vhk7h27br8gx";
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
