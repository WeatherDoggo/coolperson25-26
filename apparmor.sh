#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "Installing apparmor..."
apt-get install apparmor apparmor-utils apparmor-profiles apparmor-profiles-extra apparmor-notify -y -qq >> $LOG
systemctl enable apparmor.service --now >> $LOG
aa-status >> $LOG
#aa-enforce /etc/apparmor.d/* >> $LOG
#aa-remove-unknown >> $LOG
systemctl restart apparmor.service >> $LOG
print "Apparmor installed and enabled."
