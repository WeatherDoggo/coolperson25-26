#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $telnetneeded == "yes" || $telnetneeded == "y" ]];
then
	#cp /etc/nginx/nginx.conf ../backups/nginx.conf
  print "CONFIGURE TELNET!!!!!!!!!!!!!!!!!!"
	#cp importfiles/nginx.conf /etc/nginx/nginx.conf

else
	systemctl stop telnet.socket >> $LOG 2>>$LOG
	systemctl stop telnet.service >> $LOG 2>>$LOG
	apt-get purge *telnet* -y -qq >> $LOG
 	print "telnet removed."
fi
