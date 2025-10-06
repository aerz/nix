{ config, pkgs, ... }:
{
  home.username = "aerz";
  home.stateVersion = "25.05";

  imports = [
    ./kitty.nix
  ];

  programs.zsh = {
    enable = true;

    shellAliases = {
      la = "ls -la";
    };
  };

  programs.git = {
    enable = true;
    userName = "Agustín Cisneros";
    userEmail = "agustincc@tutanota.com";

    aliases = {
      c = "commit";
      ca = "commit -a --amend";
      co = "checkout";
      d = "diff";
      ignore = "update-index --assume-unchanged";
      lc = "log --oneline --graph";
      lf = "log --graph --all --topo-order --decorate --oneline --boundary";
      ls = "log --pretty=fuller --abbrev-commit --stat";
      lsc = "log -p --pretty=fuller --abbrev-commit";
      st = "status --short -uno";
      track = "update-index --no-assume-unchanged";
      up = "pull --rebase";
    };

    lfs.enable = true;

    ignores = [ "**/.DS_STORE" ];

    extraConfig = {
      core.autocrlf = "input";
      init.defaultBranch = "main";
    };
  };
}
