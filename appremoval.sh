#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "HAVE YOU REVISED THE LIST OF SERVICES BEING REMOVED???"
read removalconfirm
if [[ "$removalconfirm" == "yes" || "$input" == "y" ]]; then
  print "Removing processes..."
  else
  print "Rerun with proper app list configured."
  exit
fi

function appremoval () {
  systemctl stop "$1".service >> $LOG 2>>$LOG
  sudo apt-get purge --auto-remove -y -qq "$1" >> $LOG
  print "$1 removed."
}

appremoval autofs
systemctl stop avahi-daemon.socket >> $LOG 2>>$LOG
appremoval avahi-daemon
systemctl stop isc-dhcp-server6.service >> $LOG 2>>$LOG
appremoval isc-dhcp-server
appremoval bind9
appremoval dnsmasq
appremoval vsftpd
appremoval slapd
systemctl stop dovecot.socket dovecot.service >> $LOG 2>>$LOG
apt-get purge dovecot-imapd dovecot-pop3d -y -qq >> $LOG 2>>$LOG
print "message access server services removed."
systemctl stop nfs-server.service >> $LOG 2>>$LOG
apt-get purge nfs-kernel-server -y -qq >> $LOG 2>>$LOG
print "network file system service removed."
appremoval ypserv
systemctl stop cups.socket >> $LOG 2>>$LOG
appremoval cups
systemctl stop rpcbind.socket >> $LOG 2>>$LOG
appremoval rpcbind
appremoval rsync
systemctl stop smbd.service >> $LOG 2>>$LOG
appremoval samba
appremoval snmpd
appremoval tftpd-hpa
appremoval squid
appremoval nginx
appremoval xinetd
appremoval lighttpd
appremoval nikto
appremoval nmap
appremoval tcpdump
appremoval wireshark
appremoval zenmap
appremoval snmpd
appremoval inetutils-inetd
appremoval john
appremoval john-data
appremoval hydra
appremoval hydra-gtk
appremoval aircrack-ng
appremoval fcrackzip
appremoval ophcrack
appremoval ophcrack-cli
appremoval pdfcrack
appremoval rarcrack
appremoval sipcrack
appremoval irpas
appremoval zeitgeist-core
appremoval zeitgeist-datahub
appremoval rhythmbox-plugin-zeitgeist
appremoval zeitgeist
appremoval netcat
appremoval netcat-openbsd
appremoval netcat-traditional
appremoval ncat
appremoval socat
appremoval socket
appremoval sbd
appremoval sucrack
#nis
appremoval nis
#FTP
appremoval ftp
#Telnet
appremoval telnet
ufw deny 23 >> $LOG
print "port 23 closed."
#rsh-client
appremoval rsh-client
#talk
appremoval talk
#ldap
appremoval ldap-utils
#apport (collects sensitive data)
appremoval apport

#Games
apt-get purge aisleriot gnome-mahjongg gnome-mines gnome-sudoku -y -qq >> $LOG

print "Common servers, hacking tools, games, and more removed."
