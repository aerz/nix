{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "fish-you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "paysonwallach";
          repo = "fish-you-should-use";
          rev = "a332823512c0b51e71516ebb8341db0528c87926";
          hash = "sha256-MmGDFTgxEFgHdX95OjH3jKsVG1hdwo6bRht+Lvvqe5Y=";
        };
      }
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          hash = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
    ];

    interactiveShellInit = ''
      set fish_greeting
    '';

    shellAbbrs = {
      bench-fish = "hyperfine --warmup 5 'fish -i -c exit'";
      c = "clear";
    };

    shellAliases = {
      ".." = "cd ..";
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

      vim = "nvim";
      vimdiff = "nvim -d";

      rsync = "rsync -vrPlu";
      ffmpeg = "ffmpeg -hide_banner";

      sshsum = "ssh-keygen -l -f";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    MANWIDTH = "80";
  };

  xdg.configFile."fish/conf.d" = {
    source = ./conf.d;
    recursive = true;
  };
  xdg.configFile."fish/completions" = {
    source = ./completions;
    recursive = true;
  };
  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
}
