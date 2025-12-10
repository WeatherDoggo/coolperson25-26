#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

apt-get install aide -y -qq >> $LOG
aide --init >> $LOG
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
#Edit /etc/aide.conf
aide --check
