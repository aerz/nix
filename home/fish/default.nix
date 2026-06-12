{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;

    plugins = [
      # {
      #   name = "fish-you-should-use";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "paysonwallach";
      #     repo = "fish-you-should-use";
      #     rev = "a332823512c0b51e71516ebb8341db0528c87926";
      #     sha256 = "15kvxbxjwzhv8sdqxhjxb0dibawcywqklybzfl3mh41i70aq6q9j";
      #   };
      # }
      # {
      #   name = "fish-async-prompt";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "acomagu";
      #     repo = "fish-async-prompt";
      #     rev = "b90e8a8c6d1634d8f04f1532b164b99530445159";
      #     sha256 = "1s33z8fn9hjpv1bf0rsa40yh004hggk1q03ry3wgygsivpbvsr8x";
      #   };
      # }
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "0l2g922gwjd64ar41j7cp09vvvrs30ha55b85nidni4i4bbfvpda";
        };
      }
    ];

    interactiveShellInit = ''
      set fish_greeting
      fish_config theme choose doom-tomorrow-night
    '';

    shellAbbrs = {
      bench-fish = "hyperfine --warmup 5 'fish -i -c exit'";
      c = "clear";
    };

    shellAliases = {
      ".." = "cd ..";
      g = "git";
      grep = "grep --color=auto";
      sg = "ast-grep";
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

  xdg.configFile."fish/themes" = {
    source = ./themes;
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
