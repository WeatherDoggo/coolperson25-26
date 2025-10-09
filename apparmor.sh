#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "Installing apparmor..."
apt-get install apparmor apparmor-utils apparmor-profiles apparmor-profiles-extra apparmor-notify -y -qq  | sudo tee -a "$LOG" 
print "Installed. Checking status..."
systemctl status apparmor | sudo tee -a "$LOG" 
systemctl start apparmor | sudo tee -a "$LOG" 
systemctl enable apparmor | sudo tee -a "$LOG" 
aa-status | sudo tee -a "$LOG" 
aa-enforce /etc/apparmor.d/* | sudo tee -a "$LOG" 
aa-remove-unknown | sudo tee -a "$LOG" 
systemctl restart apparmor | sudo tee -a "$LOG" 
print "Apparmor configured to enforce default profiles and remove unknown profiles. Additional manual profiles may need to be added."
