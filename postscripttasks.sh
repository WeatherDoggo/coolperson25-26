#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

#Strange User IDs
print "Check for strange users:"
mawk -F: '$3 < 1000 || $3 > 65533 {print $1, $3}' /etc/passwd >> $LOG

#Privilege Escalation
print "sudo visudo /etc/sudoers, add/fix to 'Defaults use_pty'"
print "sudo visudo /etc/sudoers, add/fix to Defaults 'env_reset, timestamp_timeout=15'"
print "sudo visudo /etc/sudoers, add Defaults logfile =''/var/log/sudo.log''"
print "Remove all instances of NOPASSWD and !authenticate in /etc/sudoers"
print "Make sure hashing algorithm set in pam.unix.so is sha512 or yescrypt in pam.d (pg 647 for specific file script)"

print "PAM-AUTH-UPDATE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
print "RESTART THE COMPUTER FOR GRUB CONFIG!!!"
