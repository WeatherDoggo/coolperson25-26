#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

apt-get install auditd audispd-plugins -y -qq
systemctl enable auditd
systemctl start auditd
cp ./importfiles/auditd.conf /etc/audit/auditd.conf
print "auditd installed, enabled, configured. More work to be done here!!!!"


systemctl restart auditd
