{ config, pkgs, ... }:
{
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./kitty.nix
    ./vscode.nix
    ./zsh
    ./fzf.nix
    ./git.nix
  ];

  xdg.enable = true;
}
