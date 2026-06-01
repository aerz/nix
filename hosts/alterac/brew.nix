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
        rev = "eabc0ee13e7e28e5682fcb0ede4a333bc886ebf4";
        sha256 = "1n4yfk2gj4mv804va9cvr9nn42mf0vkshp5b62c2viidnfaf83vj";
      };
      "homebrew/homebrew-cask" = pkgs.fetchFromGitHub {
        owner = "homebrew";
        repo = "homebrew-cask";
        rev = "f05ae747a0fb5d6f21c3fd9b64406018f5870388";
        sha256 = "048cimxyqy71b6p67dvq253ixiww4d41mrh99mwk7ipbxq6jay5f";
      };
      "tw93/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "tw93";
        repo = "homebrew-tap";
        rev = "2570a9405844c3f45eb8a132afa3cbf5d8a09fbf";
        sha256 = "059js5701mbjcmc82awnmszpjqwi8cq6yar3rm1pxyxhddmxwmzx";
      };
      "anomalyco/homebrew-tap" = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "homebrew-tap";
        rev = "d81638f1a16fda9b104075be87ad1735029886b1";
        sha256 = "0nmynpm8hbvw2wpkby80hgjw1gnq0n85sdnhs8pjhiiylzak8md1";
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
