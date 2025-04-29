#!/bin/bash
LOG=../scriptlog
function print() {
  echo -e "$1" | sudo tee -a $LOG 
}

#libpam modules
apt-get purge libpam-cracklib -y -qq >> $LOG
apt-get install libpam-runtime -y -qq >> $LOG
apt-get install libpam-modules -y -qq >> $LOG
apt-get install libpam-pwquality -y -qq >> $LOG
print "libpam-runtime, libpam-pwquality, and libpam-modules installed."

#common-password
print "Configuring password policies..."
sed -i  '/try_first_pass yescrypt/ { /use_authtok/! s/$/ use_authtok / }' /etc/pam.d/common-password
sed -i  '/try_first_pass yescrypt/ { /remember=24/! s/$/ remember=24 / }' /etc/pam.d/common-password
sed -i  '/try_first_pass yescrypt/ { /minlen=14/! s/$/ minlen=14 / }' /etc/pam.d/common-password
sed -i  '/try_first_pass yescrypt/ { /enforce_for_root/! s/$/ enforce_for_root / }' /etc/pam.d/common-password
sed -i  '/pam_pwquality.so/ { /ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/! s/$/ ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 / }' /etc/pam.d/common-password

#login.defs
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   10/' /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs

#No null passwords/common-auth
sed -i 's/nullok//g' /etc/pam.d/common-auth
find /usr/share/pam-configs -type f -exec sed -i 's/nullok//g' {} +
print "Files with nullok (should be blank):"
grep -PH -- '^\h*([^#\n\r]+\h+)?pam_unix\.so\h+([^#\n\r]+\h+)?nullok\b' /usr/share/pam-configs/* | sudo tee -a $LOG
print "Null passwords disabled."

#Account lockout policy
touch /usr/share/pam-configs/faillock >> $LOG
echo -e "Name: Enforce failed login attempt counter\nDefault: no\nPriority: 0\nAuth-Type: Primary\nAuth:\n	[default=die] pam_faillock.so authfail\n	sufficient pam_faillock.so authsucc" | sudo tee -a /usr/share/pam-configs/faillock
touch /usr/share/pam-configs/faillock_notify >> $LOG
echo -e "Name: Notify on failed login attempts\nDefault: no\nPriority: 1024\nAuth-Type: Primary\nAuth:\n	requisite pam_faillock.so preauth\n" | sudo tee -a /usr/share/pam-configs/faillock-notify

#faillock.conf
cp ../importfiles/faillock.conf /etc/security/faillock.conf
chown root:root /etc/security/faillock.conf
chmod og-rwx /etc/security/faillock.conf
print "faillock.conf permissions configured."
print "faillock.conf configured."

#pwquality.conf
cp ../importfiles/pwquality.conf /etc/security/pwquality.conf
chown root:root /etc/security/pwquality.conf
chmod og-rwx /etc/security/pwquality.conf
print "pwquality.conf permissions configured."
print "pwquality.conf configured."

#pam-auth-update (common_password)
pam-auth-update --enable unix >> $LOG
pam-auth-update --enable faillock >> $LOG
pam-auth-update --enable faillock_notify >> $LOG
pam-auth-update --enable pwquality >> $LOG
pam-auth-update --enable pwhistory >> $LOG
print "PAM modules updated."
