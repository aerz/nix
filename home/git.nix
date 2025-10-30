{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user.name = "Agustín Cisneros";
      user.email = "agustincc@tutanota.com";

      alias = {
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
        undo = "reset --soft @~";
        undo-hard = "!f() { \
          git reset --hard $(git rev-parse --abbrev-ref HEAD)@{\${1-1}}; \
        }; f";
      };

      core.autocrlf = "input";
      init.defaultBranch = "main";
    };

    lfs.enable = true;

    ignores = [
      "**/.DS_STORE"
      ".vscode"
    ];
  };
}
