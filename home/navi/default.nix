{...}: {
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  xdg.dataFile."navi/cheats" = {
    source = ./cheats;
    recursive = true;
  };
}
