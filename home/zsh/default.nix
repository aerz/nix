{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./keybindings.nix
    ./alias.nix
  ];

  home.file.".hushlogin".text = "";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

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

    envExtra = ''
      export BAT_THEME="base16"
      export FZF_DEFAULT_OPTS="--color=fg:-1,fg+:#dde4e0,bg:-1,bg+:#282a2e --color=hl:#81a2be,hl+:#6aaee9,info:#f0c674,marker:#b5bd68 --color=prompt:#b294bb,spinner:#81a2be,pointer:#cc6666,header:#8abeb7 --color=border:#373b41,label:#aeaeae,query:#dde4e0 --prompt='. '"
    '';

    initContent = ''
      # delete chars Bash-style (alt+bs)
      autoload -U select-word-style
      select-word-style bash

      # zsh-autosuggestions
      export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
      export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    '';

    completionInit = ''
      # fzf use fd instead find
      # https://github.com/zimfw/fzf/blob/50964d38e4bf0d14b2055aebcac419da0d95f47c/init.zsh#L22
      export FZF_DEFAULT_COMMAND="command fd --hidden --no-ignore-vcs --exclude .git --exclude node_modules -td -tf"
      export FZF_CTRL_T_COMMAND=''${FZF_DEFAULT_COMMAND}
      export FZF_CTRL_T_OPTS="--bind ctrl-/:toggle-preview --preview 'command bat -n --color=always --line-range :500 {}'"
      export FZF_ALT_C_COMMAND="command fd --hidden --no-ignore-vcs --exclude .git --exclude node_modules -td"
      export FZF_ALT_C_OPTS="--bind ctrl-/:toggle-preview --preview 'command eza --tree --level=3 --group-directories-first --color=always -F {}'"

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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file = {
    ".local/share/navi/cheats/docker.cheat".source = ./navi/docker.cheat;
    ".local/share/navi/cheats/shell.cheat".source = ./navi/shell.cheat;
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./oh-my-posh.toml;
  };
}
