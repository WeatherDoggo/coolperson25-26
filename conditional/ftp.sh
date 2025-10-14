#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $ftpneeded == "yes" || $ftpneeded == "y" ]];
then
	#cp /etc/nginx/nginx.conf ../backups/nginx.conf

	systemctl enable ftp
	systemctl restart ftp
	#cp importfiles/nginx.conf /etc/nginx/nginx.conf

	ufw allow ftp
	print "UFW configured for ftp."
else
	systemctl stop ftp.service >> $LOG 2>>$LOG
	apt-get purge ftp -y -qq >> $LOG
 	print "ftp removed."
fi
