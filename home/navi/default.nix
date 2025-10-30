{ ... }:
{
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  home.file = {
    ".local/share/navi/cheats/docker.cheat".source = ./docker.cheat;
    ".local/share/navi/cheats/shell.cheat".source = ./shell.cheat;
  };
}
