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
rm -f /usr/share/pam-configs/faillock /usr/share/pam-configs/faillock_notify
cp ./importfiles/faillock /usr/share/pam-configs/faillock
cp ./importfiles/faillock_notify /usr/share/pam-configs/faillock_notify
rm -f /usr/share/pam-configs/pwhistory
cp ./importfiles/pwhistory /usr/share/pam-configs/pwhistory

pam-auth-update --enable unix
pam-auth-update --enable faillock
pam-auth-update --enable faillock_notify
pam-auth-update --enable pwquality
pam-auth-update --enable pwhistory

#No null passwords/common-auth
sed -i 's/nullok//g' /usr/share/pam-configs/unix
sed -i 's/nullok//g' /usr/share/pam-configs/faillock_notify
sed -i 's/nullok//g' /usr/share/pam-configs/faillock
sed -i 's/nullok//g' /etc/pam.d/common-auth
sed -i 's/nullok//g' /etc/pam.d/common-password
print "Null passwords disabled."

grep -q '^\s*auth\s+sufficient\s+pam_faillock.so\s+authsucc\s*$' /etc/pam.d/common-auth || \
  echo 'auth sufficient pam_faillock.so authsucc' | sudo tee -a /etc/pam.d/common-auth

grep -q '^\s*auth\s+\[default=die\]\s+pam_faillock.so\s+authfail\s*$' /etc/pam.d/common-auth || \
  echo 'auth [default=die] pam_faillock.so authfail' | sudo tee -a /etc/pam.d/common-auth

#pwquality.so confs
sed -i '/pam_pwquality.so/c\password        requisite                       pam_pwquality.so retry=3 minlen=15' /etc/pam.d/common-password

#pam_unix.so confs
sed -i '/pam_unix.so/c\password        [success=1 default=ignore]      pam_unix.so obscure use_authok try_first_pass yescrypt sha512 shadow rounds=100000 remember=24' /etc/pam.d/common-password
sed -i '/Password:/{
    n
    s/$/ sha512 shadow rounds=100000 remember=24/
}' /usr/share/pam-configs/unix

#logon attempt delay
echo 'auth     required     pam_faildelay.so     delay=4000000' | sudo tee -a /etc/pam.d/common-auth

#login.defs
cp ./importfiles/login.defs /etc/login.defs
print "login.defs configured."

pam-auth-update --force --package >> $LOG
print "PAM modules updated."
