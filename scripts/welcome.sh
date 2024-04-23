#!/bin/bash

clear

echo "Welcome, $USER, to Ubuntu $(lsb_release -ds)"
echo

echo "Helpful Links:"
echo " * Documentation:  https://help.ubuntu.com"
echo " * Management:     https://landscape.canonical.com"
echo " * Support:        https://ubuntu.com/advantage"
echo

echo "System Information as of $(date):"
echo
landscape-sysinfo || echo "Error: Unable to retrieve system information."
echo

updates=$(apt list --upgradable 2>/dev/null | grep -c '/')
if [[ $updates -gt 0 ]]; then
  echo "$updates updates are available."
else
  echo "No updates available."
fi
echo

echo "If you're new to Linux, you can play a game to learn the basics. (Type 'game_beginner' to play)"
