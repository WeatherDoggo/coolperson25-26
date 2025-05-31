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

announce "running users.sh..."
source ./usersconf.sh
announce "users.sh done."

announce "running password.sh..."
source ./passwordconf.sh
announce "backup.sh done."

