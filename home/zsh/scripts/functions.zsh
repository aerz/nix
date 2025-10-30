function fzf-alias() {
  alias | fzf --preview="echo {} | cut -d'=' -f2-" --height=20 --border --preview-window=down:3:wrap
}

function print-terminal-colors() {
  for i in {0..255}; do
    echo -e "$(tput setaf $i)This is color 󱓻 $i$(tput sgr0)";
  done
}

function bench-zsh() {
  case "$1" in
    --fine)
      hyperfine --warmup 1 'zsh -i -c exit'
    ;;
    *)
      for i in {1..10}; do time zsh -i -c exit; done
    ;;
  esac
}
