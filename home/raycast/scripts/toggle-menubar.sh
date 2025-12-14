#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Menubar
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌙

# @Documentation:
# @raycast.description Toggle menubar visibility
# @raycast.packageName System Tweaks

case $(defaults -currentHost read NSGlobalDomain _HIHideMenuBar) in
  1)
    defaults -currentHost write NSGlobalDomain _HIHideMenuBar -int 0
    msg="Menu bar auto-hide is now shown"
  ;;
  0)
    defaults -currentHost write NSGlobalDomain _HIHideMenuBar -int 1
    msg="Menu bar auto-hide is now hidden"
  ;;
esac

osascript -e 'tell application "System Events" to tell dock preferences to set autohide menu bar to false'
echo "${msg}"
