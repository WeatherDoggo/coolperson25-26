#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $MySQLneeded == "yes" || $MySQLneeded == "y" ]];
then
	#cp /etc/nginx/nginx.conf ../backups/nginx.conf
	#cp importfiles/nginx.conf /etc/nginx/nginx.conf

else
	systemctl stop mysql.service >> $LOG 2>>$LOG
	apt-get purge mysql -y -qq >> $LOG
 	print "MySQL removed."
fi
