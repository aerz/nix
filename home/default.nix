{ config, pkgs, ... }:
{
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./kitty.nix
    ./vscode.nix
    ./fzf.nix
    ./git.nix
    ./zsh
  ];

  xdg.enable = true;
}
