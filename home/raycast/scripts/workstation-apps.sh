#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Launch Workstation Apps
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.packageName Productivity

# Documentation:
# @raycast.description Launch apps for desktop mode

open -a "Kaygan" && \
open -a "Bluesnooze" && \
open -a "BetterDisplay"

echo "All workstation apps launched"
