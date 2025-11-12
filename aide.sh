#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

apt-get install aide -y -qq >> $LOG
cp /etc/aide/aide.conf ./backups/aide.conf
cp ./importfiles/aide.conf /etc/aide/aide.conf
aideinit
