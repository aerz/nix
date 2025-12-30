{ config, pkgs, ... }:
{
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./kitty.nix
    ./vscode.nix
    ./raycast
    ./fzf.nix
    ./bat.nix
    ./zoxide.nix
    ./navi
    ./git.nix
    ./tmux.nix
    ./prompts/oh-my-posh
    ./fish
    ./zsh
  ];

  raycast.enable = false;

  xdg.enable = true;
}
