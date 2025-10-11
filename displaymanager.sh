#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $OS == "mint" ]]; then
  print "Configure lightdm!"
elif [[ $OS == "ubuntu" ]]; then
  cp ./importfiles/custom.conf /etc/gdm/custom.conf
  cp ./importfiles/custom.conf /etc/gdm3/custom.conf
  print "gdm & gdm3 custom.conf configured. More work to be done!!!!"
fi
