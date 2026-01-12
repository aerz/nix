{...}: {
  programs.zsh = {
    shellAliases = {
      ".." = "cd ..";
      c = "clear";
      g = "git";
      grep = "grep --color=auto";
      ls = "eza --icons=always --color=always --group-directories-first";
      find = "fd";
      l = "ls -lgh";
      ll = "ls -l";
      la = "ls -la";
      tree = "eza --icons --tree --group-directories-first";
      cp = "cp -vi";
      mv = "mv -vi";
      rm = "rm -vI";
      duh = "du -sh";

      bench = "hyperfine";
      vim = "nvim";
      vimdiff = "nvim -d";

      rsync = "rsync -vrPlu";
      ffmpeg = "ffmpeg -hide_banner";

      sshsum = "ssh-keygen -l -f";
    };

    shellGlobalAliases = {
      C = "| pbcopy";
    };
  };
}
