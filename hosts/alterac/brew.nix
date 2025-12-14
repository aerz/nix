{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [
      "bitwarden-cli"
      "git"
      "mas"
      "tw93/tap/mole"
    ];

    casks = [
      "betterdisplay"
      "bluesnooze"
      "brave-browser"
      "helium-browser"
      "hyperkey"
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
    ];
    greedyCasks = true;

    masApps = {
      "TickTick" = 966085870;
      "Tailscale" = 1475387142;
    };
  };
}
