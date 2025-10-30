{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion = {
      enable = true;
      strategy = [ ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "fac145167f7ec1861233c54de0c8900b09c650fe";
          hash = "sha256-1Ior+/9e+M+Fc1u0uq5HhknlGRS96q7tazhEE6rmx9Y=";
        };
      }
      {
        name = "fzf-git";
        src = pkgs.fetchFromGitHub {
          owner = "junegunn";
          repo = "fzf-git.sh";
          rev = "c823ffd521cb4a3a65a5cf87f1b1104ef651c3de";
          hash = "sha256-G5b6s3p4Lrh2YQyBKE3Lzh78USR1tKlR/YqTMr3mXsI=";
        };
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "64dd9e3ff977e4ae7d024602b2d9a7a4f05fd8f6";
          hash = "sha256-u3abhv9ewq3m4QsnsxT017xdlPm3dYq5dqHNmQhhcpI=";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "87ce96b1862928d84b1afe7c173316614b30e301";
          hash = "sha256-1+w0AeVJtu1EK5iNVwk3loenFuIyVlQmlw8TWliHZGI=";
        };
      }
    ];

    dotDir = "${config.xdg.configHome}/zsh";

    initContent = ''
      # delete chars Bash-style (alt+bs)
      autoload -U select-word-style
      select-word-style bash

      # scripts
      ${builtins.readFile ./scripts/functions.zsh}
    '';

    completionInit = ''
      # fzf
      _fzf_compgen_path() {
        command fd -H --no-ignore-vcs -E .git -td -tf . "''${1}"
      }

      _fzf_compgen_dir() {
          command fd -H --no-ignore-vcs -E .git -td . "''${1}"
      }

      # fzf-tab
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=3 --color=always $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --tree --level=3 --color=always $realpath'

      # zsh-history-substring-search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="1"

      # zsh-autosuggestions
      export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
      export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      # completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)EZA_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/zcompcache"

      [[ ! -d "${config.xdg.cacheHome}/zsh" ]] || \
        mkdir -p "${config.xdg.cacheHome}/.cache}/zsh"

      autoload -Uz compinit
      compinit -d "${config.xdg.cacheHome}/zsh/zcompdump-''${ZSH_VERSION}"
    '';

    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";

      append = true;
      share = true;

      ignoreSpace = true;
      ignoreAllDups = true;
      saveNoDups = true;
      ignoreDups = true;
      findNoDups = true;
    };
  };
}
