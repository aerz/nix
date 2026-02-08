#!/usr/bin/env bash

# source
# https://github.com/franckrasolo/dotfiles.nix/blob/e1db7c391acc506bcea972a9172c48e6acd72bc2/darwin/home/aerospace/resize-floating-centered.sh

set -o errexit
set -o nounset
set -o pipefail

osascript -e "
tell application \"System Events\"
  set _app to name of first application process whose frontmost is true
  tell process _app
    set _window to front window
    set {x, y, width, height} to _window's position & _window's size
    set position of _window to {x - ($1 / 2), y - ($2 / 2)}
    set size of _window to {width + $1, height + $2}
    activate
  end tell
end tell
" && \
open -g "raycast://script-commands/toast?arguments=Floating%20window%20resized"
