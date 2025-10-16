#!/bin/bash
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

touch /etc/cron.allow
touch /etc/cron.deny
chown root:root /etc/cron.allow
chmod og-rwx /etc/cron.allow
chown root:root /etc/cron.deny
chmod og-rwx /etc/cron.deny
chmod 600 /etc/cron.allow
chmod 600 /etc/cron.deny
chmod 700 /var/spool/cron/crontabs
print "Cron.deny & cron.allow created and limited if they didn't exist."

#GRUB
chmod 600 /boot/grub/grub.cfg
chown root:root /boot/grub/grub.cfg
print "GRUB permissions configured."

#DNS Resolution
chmod 644 /etc/resolv.conf
print "resolv.conf permissions configured."

# Basic credential files
chmod 644 /etc/passwd
chmod 644 /etc/group
chmod 600 /etc/gshadow
print "/etc/passwd, /etc/group, /etc/gshadow permissions configured."

# Home directories and SSH
chmod 700 /home/* -R
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_rsa
print "User home and SSH keys permissions configured."

# Logs
chown root:root /var/log/auth.log /var/log/syslog
chmod 600 /var/log/auth.log /var/log/syslog
print "Critical logs permissions configured."

# tmp directories
chmod +t /tmp
chmod +t /var/tmp
print "/tmp and /var/tmp sticky bit set."

# Root directory
chmod 700 /root
print "/root directory permissions configured."

#/home
chown root:root /home
print "/home is now owned by root."

chmod 600 /swapfile
print "swapfile secured."

