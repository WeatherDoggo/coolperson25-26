#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "HAVE YOU REVISED THE LIST OF SERVICES BEING REMOVED???"
read removalconfirm
if [[ "$removalconfirm" == "yes" || "$removalconfirm" == "y" ]]; then
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
appremoval slapd
systemctl stop dovecot.socket dovecot.service >> $LOG 2>>$LOG
apt-get purge dovecot-imapd dovecot-pop3d -y -qq >> $LOG 2>>$LOG
#print "message access server services removed."
appremoval nfs*
#appremoval ypserv
#appremoval rpcbind
appremoval cups
#appremoval rsync
appremoval snmpd
appremoval tftpd-hpa
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
appremoval sucrack
appremoval snort
appremoval doona
appremoval xprobe
appremoval imagemagick*
appremoval openvpn
appremoval filezilla
appremoval bluetooth
appremoval bluez*
appremoval amule
print "remove tftpd?????????"

#appremoval burpsuite (broken)
appremoval reaver
appremoval mdk3
appremoval mdk4
appremoval proxychains
appremoval tsocks
appremoval scapy
appremoval hping3
appremoval airgraph-ng
appremoval zmap
appremoval masscan
appremoval ltrace
appremoval strace
appremoval gdb
appremoval radare2
appremoval hashcat
appremoval lprng
appremoval netcat
appremoval netcat-openbsd
appremoval netcat-traditional
appremoval ncat
appremoval socat
appremoval sbd
appremoval rlogin
#nis
appremoval nis
#rsh (remote shell)
appremoval rsh*
#talk
appremoval talk
#ldap
appremoval ldap-utils
#apport (collects sensitive data)
appremoval apport
#FTP
appremoval ftp
#Metasploit (broken)

#telnet
systemctl stop telnet.socket >> $LOG 2>>$LOG
systemctl stop telnet.service >> $LOG 2>>$LOG
apt-get purge *telnet* -y -qq >> $LOG
print "telnet removed."
ufw deny 23 >> $LOG
print "port 23 closed."

#Games
appremoval pvpgn
apt-get purge aisleriot gnome-mahjongg gnome-mines gnome-sudoku -y -qq >> $LOG
appremoval zangband

print "Common servers, hacking tools, games, and more removed."
