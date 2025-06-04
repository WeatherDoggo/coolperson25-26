#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}
function announce() {
  echo -e "${\033[1;36m}$1${\033[1;36m}" | sudo tee -a $LOG 
}
announce "HAS UPDATE, UPGRADE, & AUTOREMOVE BEEN RUN?"
read runconfirm
if [[ $runconfirm == "yes" || $runconfirm == "y" ]]; then
  announce "Proceeding..."
else
  announce "Exiting..."
  exit
fi
announce "running backup.sh..."
source ./logs/backup.sh
announce "backup.sh done."

announce "running manualscans.sh..."
source ./manualscans.sh
announce "manualscans.sh done."
announce "Finish the forensics questions now."
read done1
announce "Are you sure you are done with the forensics questions?"
read done2
announce "Proceeding..."

announce "running usersconf.sh..."
source ./usersconf.sh
announce "users.sh done."

announce "running passwordconf.sh..."
source ./passwordconf.sh
announce "backup.sh done."

announce "running firewall.sh..."
source ./firewall.sh
announce "firewall.sh done."

apt-get autoclean -y -qq >> $LOG
apt-get clean -y -qq >> $LOG
apt-get autoremove -y -qq >> $LOG
print "Unecessary packages removed."

