#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}
function announce() {
  echo -e "\033[1;36m$1\033[0m" | sudo tee -a $LOG 
}
announce "HAS UPDATE, UPGRADE, & AUTOREMOVE BEEN RUN?"
read runconfirm
if [[ $runconfirm == "yes" || $runconfirm == "y" ]]; then
  announce "Proceeding..."
else
  announce "Exiting..."
  exit
fi
announce "Running backup.sh..."
source ./logs/backup.sh
announce "backup.sh done."

announce "Running manualscans.sh..."
source ./manualscans.sh
announce "manualscans.sh done."
announce "Finish the forensics questions now."
read done1
announce "Are you sure you are done with the forensics questions?"
read done2
announce "Proceeding..."

neededservices=()
function isitneeded() {
  announce "Is $1 needed?"
  read input
  varname="${1}needed"
  eval "$varname=\"$input\""
  if [[ "$input" == "yes" || "$input" == "y" ]]; then
    announce "$1 marked as needed with var $varname."
    neededservices+=("$1 is needed")
  else
    announce "$1 marked as not needed."
  fi
}
isitneeded ssh
isitneeded telnet
isitneeded mail
isitneeded printing
isitneeded MySQL
isitneeded apache
isitneeded nginx
isitneeded squid
isitneeded samba
isitneeded FTP
#isitneeded(docker) SPECIFIFY WHAT DOCKER IS USED WITH SO IT ISNT DISABLED BY ACCIDENT!
announce "Critical services marked."

announce "Running universalfileperms.sh..."
source ./universalfileperms.sh
announce "universalfileperms.sh done."

announce "Running usersconf.sh..."
source ./usersconf.sh
announce "users.sh done."

announce "Running passwordconf.sh..."
source ./passwordconf.sh
announce "passwordconf.sh done."

announce "Running firewall.sh..."
source ./firewall.sh
announce "firewall.sh done."

announce "Running appremoval.sh..."
source ./appremoval.sh
announce "appremoval.sh done."

announce "Running misc.sh..."
source ./misc.sh
announce "misc.sh done."

function confservice() {
  varname="${1}needed"
  eval "needed=\$$varname"
  if [[ "$needed" == "yes" || "$needed" == "y" ]]; then
    announce "Running $1.sh..."
    source ./$1.sh
    announce "$1.sh done."
  else
    announce "$1 not needed, skipping configuration."
  fi
}
confservice ssh
confservice nginx

apt-get autoclean -y -qq >> $LOG
apt-get clean -y -qq >> $LOG
apt-get autoremove -y -qq >> $LOG
announce "Unnecessary packages removed."
announce "-------SCRIPT COMPLETE :3-------"

