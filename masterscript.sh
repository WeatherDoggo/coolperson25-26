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

OS=""
announce "Mint or Ubuntu?"
read OS
if [[ $OS == "mint" || $OS == "Mint" ]]; then
  OS="mint"
  announce "OS set to Mint. MANUALLY DO THE AUTOMATIC UPDATES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
elif [[ $OS == "ubuntu" || $OS == "Ubuntu" ]]; then
  OS="ubuntu"
  announce "OS set to Ubuntu."
else
  announce "OS not recognized. Exiting..."
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

function isitneeded() {
  announce "Is $1 needed?"
  read input
  varname="${1}needed"
  eval "$varname=\"$input\""
  if [[ "$input" == "yes" || "$input" == "y" ]]; then
    announce "$1 marked as needed with var $varname."
  else
    announce "$1 marked as not needed."
  fi
}
isitneeded ssh
isitneeded telnet
isitneeded printing
isitneeded MySQL
isitneeded apache2
isitneeded nginx
isitneeded squid
isitneeded samba
isitneeded ftp
#isitneeded(docker) SPECIFIFY WHAT DOCKER IS USED WITH SO IT ISNT DISABLED BY ACCIDENT!
announce "Critical services marked."

#announce "Running browserconfig.sh..."
#source ./browserconfig.sh
#announce "browserconfig.sh done."

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

#Conditional configurations
announce "Conditional configurations:"

announce "Running ssh.sh..."
source ./conditional/ssh.sh
announce "ssh.sh done."

announce "Running telnet.sh..."
source ./conditional/telnet.sh
announce "telnet.sh done."

announce "Running printing.sh..."
source ./conditional/printing.sh
announce "printing.sh done."

announce "Running MySQL.sh..."
source ./conditional/MySQL.sh
announce "MySQL.sh done."

announce "Running apache2.sh..."
source ./conditional/apache2.sh
announce "apache2.sh done."

announce "Running nginx.sh..."
source ./conditional/nginx.sh
announce "nginx.sh done."

announce "Running squid.sh..."
source ./conditional/squid.sh
announce "squid.sh done."

announce "Running samba.sh..."
source ./conditional/samba.sh
announce "samba.sh done."

announce "Running ftp.sh..."
source ./conditional/ftp.sh
announce "ftp.sh done."

announce "Conditional configurations complete."

announce "Running manualscans2.sh..."
source ./manualscans.sh
announce "manualscans2.sh done."

announce "Running postscripttasks.sh..."
source ./postscripttasks.sh
announce "postscipttasks.sh done."

announce "Running longscans.sh..."
source ./logs/longscans.sh
announce "longscans.sh done."

apt-get autoclean -y -qq >> $LOG
apt-get clean -y -qq >> $LOG
apt-get autoremove -y -qq >> $LOG
announce "Unnecessary packages removed."
announce "-------SCRIPT COMPLETE :3-------"

