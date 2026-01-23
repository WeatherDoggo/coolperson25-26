#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}
while true; do
  print "HAVE YOU REVISED THE LIST OF SERVICES BEING REMOVED???"
  read removalconfirm
  if [[ "$removalconfirm" == "yes" || "$removalconfirm" == "y" ]]; then
    print "Removing processes..."
    break
  else
    print "Rerun with proper app list configured, or type y."
  fi
done

function appremoval () {
  systemctl stop "$1".service >> $LOG 2>>$LOG
  sudo apt-get purge --auto-remove -y -qq "$1" | sudo tee -a $LOG
  print "$1 removed."
}
systemctl stop cups
systemctl disable cups
systemctl stop avahi-daemon
systemctl disable avahi-daemon

appremoval autofs
systemctl stop avahi-daemon.socket 2>>$LOG  | sudo tee -a $LOG
appremoval avahi-daemon
#DHCP server
systemctl stop isc-dhcp-server6.service 2>>$LOG | sudo tee -a $LOG
appremoval isc-dhcp-server
#DNS server
systemctl stop named.service
apt-get remove bind9 --auto-remove -y -qq "$1" | sudo tee -a $LOG
appremoval dnsmasq
#ldap server
appremoval slapd
#Message access server services
systemctl stop dovecot.socket dovecot.service 2>>$LOG | sudo tee -a $LOG
apt-get purge dovecot-imapd dovecot-pop3d -y -qq 2>>$LOG | sudo tee -a $LOG
#Network file services
appremoval nfs*
appremoval ypserv
appremoval rpcbind
appremoval cups
appremoval rsync
appremoval snmpd
appremoval tftpd-hpa
appremoval xinetd
appremoval lighttpd
appremoval nikto
appremoval nmap
appremoval tcpdump
appremoval wireshark
appremoval zenmap
appremoval snmp
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
appremoval filezilla
appremoval bluetooth
appremoval bluez*
appremoval amule
appremoval tftpd-hpa
appremoval hexchat
appremoval warpinator
appremoval transmission-gtk
appremoval endless-sky
appremoval bleachbit
#Services
appremoval openvpn
appremoval mongod*
appremoval nordvpn
appremoval protonvpn*
appremoval rsh*
appremoval talk
appremoval ldap-utils
appremoval apport
appremoval ftp
appremoval tnftp
appremoval nis
appremoval jenkins
appremoval grafana*
appremoval postgresql
appremoval postgresql\*
appremoval redis-server
appremoval mariadb-*


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
