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
    ];

    interactiveShellInit = ''
      set fish_greeting
    '';

    functions = {
      C = {
        description = "Copy stdin into clipboard";
        body = "pbcopy";
      };
      print-term-colors = {
        description = "Show all terminal colors (0-255)";
        body = ''
          for i in (seq 0 255)
            echo (tput setaf $i)"This is color 󱓻 $i"(tput sgr0)
          end
        '';
      };
    };

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
}
