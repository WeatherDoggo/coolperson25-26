#!/bin/bash
#TO-DO:
#Transfer over file perms from mainscript
#add some for password-related files

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
