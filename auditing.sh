#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

apt-get install auditd audispd-plugins -y -qq
systemctl enable auditd
systemctl start auditd
print "auditd installed, enabled, and started. More work to be done here!!!!"


#curl -o /etc/audit/rules.d/audit.rules https://raw.githubusercontent.com/Neo23x0/auditd/master/audit.rules
#augenrules --load
#systemctl restart auditd
