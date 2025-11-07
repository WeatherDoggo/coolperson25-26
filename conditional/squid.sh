#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $squidneeded == "yes" || $squidneeded == "y" ]];
then
	#cp /etc/nginx/nginx.conf ../backups/nginx.conf
	print "CONFIGURE SQUID!!!!!!!!!!!!!!!!!"
	#cp importfiles/nginx.conf /etc/nginx/nginx.conf
	systemctl enable squid.service >> $LOG
	systemctl restart squid.service >> $LOG
	systemctl status squid.service

else
	systemctl stop squid >> $LOG 2>>$LOG
	apt-get purge squid -y -qq >> $LOG
 	print "squid removed."
fi
