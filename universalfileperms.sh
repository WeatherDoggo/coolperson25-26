#!/bin/bash
#TO-DO:
#Transfer over file perms from mainscript
#add some for password-related files
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}


chmod 640 /etc/shadow >> $LOG
print "/etc/shadow permissions configured."

chmod 600 /etc/sysctl.conf >> $LOG
print "sysctl.conf permissions configured."

#Password related
chown root:root /etc/security/faillock.conf
chmod og-rwx /etc/security/faillock.conf
print "faillock.conf permissions configured."

chown root:root /etc/security/pwquality.conf
chmod og-rwx /etc/security/pwquality.conf
print "pwquality.conf permissions configured."

#Cron
chown root:root /etc/crontab
chmod og-rwx /etc/crontab
chown root:root /etc/crontab
chown root:root /etc/cron.hourly/
chmod og-rwx /etc/cron.hourly/
chown root:root /etc/cron.daily/
chmod og-rwx /etc/cron.daily/
chown root:root /etc/cron.weekly/
chmod og-rwx /etc/cron.weekly/
chown root:root /etc/cron.monthly/
chmod og-rwx /etc/cron.monthly/
chown root:root /etc/cron.d/
chmod og-rwx /etc/cron.d/
print "cron file permissions configured."

#GRUB
chmod 600 /boot/grub/grub.cfg
chown root:root /boot/grub/grub.cfg
print "GRUB permissions configured."

#DNS Resolution
chmod 644 /etc/resolv.conf
print "resolv.conf permissions configured."
