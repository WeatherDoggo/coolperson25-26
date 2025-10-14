#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $sambaneeded == "yes" || $sambaneeded == "y" ]];
then
	#cp /etc/nginx/nginx.conf ../backups/nginx.conf
	print "CONFIGURE SAMBA!!!!!!!!!!!!!!!!!"
	#cp importfiles/nginx.conf /etc/nginx/nginx.conf

else
	systemctl stop samba.service >> $LOG 2>>$LOG
	apt-get purge samba -y -qq >> $LOG
 	print "samba removed."
fi
