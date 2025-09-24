#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "Installing apparmor..."
apt install apparmor apparmor-utils apparmor-profiles apparmor-profiles-extra apparmor-notify >> $LOG
print "Installed. Checking status..."
systemctl status apparmor >> $LOG
systemctl enable apparmor >> $LOG
systemctl start apparmor >> $LOG
aa-status >> $LOG
aa-enforce /etc/apparmor.d/* >> $LOG
aa-remove-unknown >> $LOG
systemctl reload apparmor >> $LOG
print "Apparmor configured to enforce default profiles and remove unknown profiles. Additional manual profiles may need to be added."
