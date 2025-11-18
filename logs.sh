#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

apt-get install rsyslog -y -qq >>$LOG
systemctl enable rsyslog.service --now
print "rsyslog installed and enabled."

chgrp adm /var/log/syslog
chown syslog /var/log/syslog

#Auditd
apt-get install auditd audispd-plugins -y -qq
systemctl enable auditd.service --now
cp ./importfiles/auditd.conf /etc/audit/auditd.conf
print "auditd installed, enabled, configured. More work to be done here!!!!"
systemctl kill auditd -s SIGHUP
systemctl enable auditd.service --now
