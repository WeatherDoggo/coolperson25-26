#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#Basic Firewall Conf
print "Enabling firewall..."
apt-get install ufw -y -qq >> $LOG
apt-get purge iptables-persistent -y -qq >> $LOG
print "iptables-persistent removed."
ufw enable --now >> $LOG
ufw default deny incoming >> $LOG
ufw default allow outgoing >> $LOG
ufw default deny routed >> $LOG
ufw logging on
ufw deny 1337 >> $LOG
ufw allow in on lo
ufw allow out on lo
ufw deny in from 127.0.0.0/8
ufw deny in from ::1
print "Firewall enabled, port 1337 closed, and loopback traffic is configured."
#MAKE IT SO LISTENING PROCESSES IS CHECKED BEFORE CLOSING PORT 1337!!!!!!!
