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

      # Doom Tomorrow Night
      set -l background     1d1f21
      set -l foreground     c5c8c6
      set -l comment        5a5b5a
      set -l red            cc6666
      set -l orange         de935f
      set -l yellow         f0c574
      set -l green          b5bd68
      set -l aqua           8abeb7
      set -l blue           81a2be
      set -l violet         b294bb
      set -l magenta        c9b4cf

      set -g fish_color_command           $violet
      set -g fish_color_quote             $green
      set -g fish_color_redirection       $aqua
      set -g fish_color_end               $violet
      set -g fish_color_error             $red
      set -g fish_color_param             normal --bold
      set -g fish_color_comment           $comment
      set -g fish_color_operator          $foreground
      set -g fish_color_escape            $orange
      set -g fish_color_autosuggestion    $comment

      set -g fish_color_cwd               normal --bold
      set -g fish_color_cwd_root          $red
      set -g fish_color_valid_path        --bold --underline

      set -g fish_color_user              $green
      set -g fish_color_host              $foreground

      set -g fish_pager_color_prefix      $violet --bold
      set -g fish_pager_color_completion  normal
      set -g fish_pager_color_description $aqua
      set -g fish_pager_color_progress    $background --background=$violet

      set -g fish_color_search_match      $background --background=$yellow
      set -g fish_color_selection         $foreground --bold --background=$comment
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
      man = {
        description = "Man command with fzf";
        body = ''
          if test (count $argv) -gt 0
            command man $argv
            return
          end

          set -l page (command man -k . | fzf | awk '{print $1}')
          test -n "$page"; and command man $page
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

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    MANWIDTH = "80";
  };
}
