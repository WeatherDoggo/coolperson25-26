#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

apt-get install rsyslog -y -qq >>$LOG
systemctl enable rsyslog.service --now
print "rsyslog installed and enabled."

chown syslog /var/log/syslog
