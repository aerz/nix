{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./alias.nix
    ./keybindings.nix
  ];

  home.file.".hushlogin".text = "";

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file = {
    ".local/share/navi/cheats/docker.cheat".source = ./navi/docker.cheat;
    ".local/share/navi/cheats/shell.cheat".source = ./navi/shell.cheat;
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./oh-my-posh.toml;
  };
}
