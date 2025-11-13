#!/bin/bash
#Makes a copy of all important files and saves them to a backups folder
mkdir -pv ./backups
chmod 777 ./backups

function backup {
  cp $1 ./backups/$(basename "$1")
  chmod 777 ./backups/$(basename "$1")
}
chmod 777 ./logs/main.log
touch backups/cronjobs.txt
crontab -l > backups/cronjobs.txt #FIX
backup /etc/group
backup /etc/passwd
backup /etc/pam.d/common-password
backup /etc/login.defs
backup /etc/pam.d/common-auth
backup /etc/security/faillock.conf
backup /etc/security/pwquality.conf
backup /etc/sysctl.conf
backup /etc/security/limits.conf
if [[ "$OS" == "mint" ]]; then
  backup /etclinuxmint/mintupdate.conf
elif [[ $OS == "ubuntu" ]]; then
  backup /etc/gdm/custom.conf
  backup /etc/gdm3/custom.conf
fi
print "Critical files backed up. More files may need to conditionally be backed up depending on the application!"
