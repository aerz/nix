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
      "iina"
      "zen"
      "spotify"
      "notunes"
      "obsidian"
      "visual-studio-code"
    ];
    greedyCasks = true;

    masApps = {
      "TickTick" = 966085870;
      "Tailscale" = 1475387142;
    };
  };
}
