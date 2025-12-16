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
sed -i '/pam_pwquality\.so/ s/$/ minlen=15/' /usr/share/pam-configs/pwquality
print "minlen added to pwquality pam-configs."

print "Setting up faillock, pwhistory, and faillock_notify..."
cp ./importfiles/faillock /usr/share/pam-configs/faillock
cp ./importfiles/faillock_notify /usr/share/pam-configs/faillock_notify
cp ./importfiles/pwhistory /usr/share/pam-configs/pwhistory
cp ./importfiles/fscrypt /usr/share/pam-configs/fscrypt
cp ./importfiles/unix /usr/share/pam-configs/unix
cp ./importfiles/faildelay /usr/share/pam-configs/faildelay

pam-auth-update --enable unix
pam-auth-update --enable faillock
pam-auth-update --enable faillock_notify
pam-auth-update --enable pwquality
pam-auth-update --enable pwhistory
pam-auth-update --enable fscrypt
pam-auth-update --enable faildelay
pam-auth-update --force --package >> $LOG

#grep -q '^\s*auth\s+sufficient\s+pam_faillock.so\s+authsucc\s*$' /etc/pam.d/common-auth || \
#  echo 'auth sufficient pam_faillock.so authsucc' | sudo tee -a /etc/pam.d/common-auth

#grep -q '^\s*auth\s+\[default=die\]\s+pam_faillock.so\s+authfail\s*$' /etc/pam.d/common-auth || \
#  echo 'auth [default=die] pam_faillock.so authfail' | sudo tee -a /etc/pam.d/common-auth

#pwquality.so confs
#sed -i '/pam_pwquality.so/c\password        requisite                       pam_pwquality.so retry=3 minlen=14' /etc/pam.d/common-password

#logon attempt delay
#echo 'auth     required     pam_faildelay.so     delay=4000000' | sudo tee -a /etc/pam.d/common-auth

#login.defs
cp ./importfiles/login.defs /etc/login.defs
print "login.defs configured."

print "PAM modules updated."
