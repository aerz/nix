{ config, pkgs, ... }:
{
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./kitty.nix
    ./vscode.nix
    ./fzf.nix
    ./bat.nix
    ./zoxide.nix
    ./navi
    ./git.nix
    ./prompts/oh-my-posh
    ./fish
    ./zsh
  ];

  xdg.enable = true;
}
