#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "Installing apparmor..."
apt-get install apparmor apparmor-utils apparmor-profiles apparmor-profiles-extra apparmor-notify -y -qq >> $LOG
systemctl start apparmor >> $LOG
systemctl enable apparmor >> $LOG
aa-status >> $LOG
aa-enforce /etc/apparmor.d/* >> $LOG
aa-remove-unknown >> $LOG
systemctl restart apparmor | sudo tee -a "$LOG" 
print "Apparmor configured to enforce default profiles and remove unknown profiles. Additional manual profiles may need to be added."
