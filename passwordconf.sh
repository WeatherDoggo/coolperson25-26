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

grep -q '^\s*auth\s+sufficient\s+pam_faillock.so\s+authsucc\s*$' /etc/pam.d/common-auth || \
  echo 'auth sufficient pam_faillock.so authsucc' | sudo tee -a /etc/pam.d/common-auth

grep -q '^\s*auth\s+\[default=die\]\s+pam_faillock.so\s+authfail\s*$' /etc/pam.d/common-auth || \
  echo 'auth [default=die] pam_faillock.so authfail' | sudo tee -a /etc/pam.d/common-auth

#minimum password length & passwords are remembered
sed -i '/pam_unix.so.*retry=/ s/remember=[0-9]\+/remember=24/' /etc/pam.d/common-password
sed -i '/pam_unix.so.*retry=3/ { /remember=/! s/$/ remember=24/ }' /etc/pam.d/common-password
print "VERIFY THIS WORKS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

sed -i '/pam_pwquality.so.*retry=3/ s/minlen=[0-9]\+/minlen=12/' /etc/pam.d/common-password
sed -i '/pam_pwquality.so.*retry=3/ { /minlen=/! s/$/ minlen=12/ }' /etc/pam.d/common-password

#login.defs
cp ./importfiles/login.defs /etc/login.defs
print "login.defs configured."

pam-auth-update --force --package >> $LOG
print "PAM modules updated."
