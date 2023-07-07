#!/bin/bash

echo "Welcome to Ubuntu $(lsb_release -rs) (GNU/Linux $(uname -r))"
echo
echo " * Documentation:  https://help.ubuntu.com"
echo " * Management:     https://landscape.canonical.com"
echo " * Support:        https://ubuntu.com/advantage"
echo
echo "  System information as of $(date "+%a %b %e %T UTC%:z %Y" | sed 's/:/+/')"
echo
echo "$(landscape-sysinfo)"
echo
updates=$(apt list --upgradable 2>/dev/null | grep -c '/')
if [[ $updates -gt 0 ]]; then
  echo "$updates updates can be applied."
else
  echo "No updates available."
fi
