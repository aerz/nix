{
  config,
  pkgs,
  ...
}: {
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./aerospace
    ./emacs.nix
    ./kitty.nix
    ./vscode.nix
    ./zed
    ./calibre.nix
    ./raycast
    ./fzf.nix
    ./atuin.nix
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

  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
  };

  home.sessionPath = [
    "${config.xdg.dataHome}/go/bin"
  ];

  xdg.enable = true;
}
