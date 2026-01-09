#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Set Default Browser to Brave
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌐

osascript -e 'quit app "Brave Browser"' 2>/dev/null
sleep 2
defaultbrowser safari
echo "Please confirm browser change"
open -a "Brave Browser" --args --make-default-browser
