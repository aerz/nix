{
  config,
  pkgs,
  ...
}: {
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./aerospace.nix
    ./kitty.nix
    ./vscode.nix
    ./zed
    ./calibre.nix
    ./raycast
    ./fzf.nix
    ./bat.nix
    ./zoxide.nix
    ./navi
    ./direnv.nix
    ./gpg.nix
    ./git.nix
    ./tmux.nix
    ./prompts/oh-my-posh
    ./fish
    ./zsh
  ];

  xdg.enable = true;
}
