#!/bin/bash

clear
echo "Welcome $USER to Ubuntu $(lsb_release -rs) (GNU/Linux $(uname -r))"
echo
echo " * Documentation:  https://help.ubuntu.com"
echo " * Management:     https://landscape.canonical.com"
echo " * Support:        https://ubuntu.com/advantage"
echo
echo "  System information as of $(date)"
echo
landscape-sysinfo || echo "Error: Unable to retrieve system information."
echo
updates=$(apt list --upgradable 2>/dev/null | grep -c '/')
if [[ $updates -gt 0 ]]; then
  echo "$updates updates can be applied."
else
  echo "No updates available."
fi
echo "If you are new to Linux, you can play a game to learn the basics. (Type 'game_beginner' to play)"
