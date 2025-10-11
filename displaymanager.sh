#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $OS == "mint" ]]; then
  print "Configure lightdm!"
elif [[ $OS == "ubuntu" ]]; then
  print "Check /etc/gdm(3)/custom.conf for improper AutomaticLogin & delete and User/Group specification & TCP is disallowed"
fi
