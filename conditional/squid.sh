#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $squidneeded == "yes" || $squidneeded == "y" ]];
then
	cp /etc/squid/squid.conf ./backups/squid.conf
	cp ./imporfiles/squid.conf /etc/squid/squid.conf
	print "CONFIGURE SQUID CONF FILE!!!!!!!!!!!!!!!!!"
	sudo ufw allow 'Squid' >> $LOG
	systemctl enable squid.service >> $LOG
	systemctl restart squid.service >> $LOG
	systemctl status squid.service

else
	systemctl stop squid.service >> $LOG 2>>$LOG
	apt-get purge squid -y -qq >> $LOG
 	print "squid removed."
fi
