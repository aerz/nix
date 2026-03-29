{pkgs, ...}: {
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./aerospace
    ./mas.nix
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

  home.packages = [
    pkgs.mas
  ];

  xdg.enable = true;
}
