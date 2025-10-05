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
      "git"
      "mas"
    ];

    casks = [
      "brave-browser"
      "telegram-desktop"
      "localsend"
      "iina"
      "zen"
      "spotify"
      "pearcleaner"
      "notunes"
      "obsidian"
      "visual-studio-code"
      "kitty"
    ];
    greedyCasks = true;

    masApps = {
      "TickTick" = 966085870;
      "Tailscale" = 1475387142;
    };
  };
}
