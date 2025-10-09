#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a $LOG 
}

#libpam modules
print "Installing PAM modules..."
DEBIAN_FRONTEND=noninteractive sudo apt-get purge libpam-cracklib -y -qq >> $LOG
DEBIAN_FRONTEND=noninteractive sudo apt-get install libpam-runtime libpam-modules libpam-pwquality -y -qq >> $LOG
print "libpam-runtime, libpam-pwquality, and libpam-modules installed."

#faillock.conf
cp ./importfiles/faillock.conf /etc/security/faillock.conf
print "faillock.conf configured."
#pwquality.conf
cp ./importfiles/pwquality.conf /etc/security/pwquality.conf
print "pwquality.conf configured."

print "Deploying PAM config fragments for faillock..."
rm -f /usr/share/pam-configs/faillock /usr/share/pam-configs/faillock_notify
cp ./importfiles/faillock /usr/share/pam-configs/faillock
cp ./importfiles/faillock_notify /usr/share/pam-configs/faillock_notify

#No null passwords/common-auth
sed -i 's/nullok//g' /etc/pam.d/common-auth
print "Null passwords disabled."

#login.defs
cp ./importfiles/login.defs /etc/login.defs
print "login.defs configured."

pam-auth-update --force --package >> $LOG
print "PAM modules updated."
