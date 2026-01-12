{
  config,
  pkgs,
  ...
}: {
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./kitty.nix
    ./vscode.nix
    ./calibre.nix
    ./raycast
    ./fzf.nix
    ./bat.nix
    ./zoxide.nix
    ./navi
    ./dev.nix
    ./git.nix
    ./tmux.nix
    ./prompts/oh-my-posh
    ./fish
    ./zsh
  ];

  xdg.enable = true;
}
