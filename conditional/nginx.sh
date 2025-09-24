#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $nginxneeded == "yes" || $nginxneeded == "y" ]];
then
	cp /etc/nginx/nginx.conf ../backups/nginx.conf
	chmod 777 ../backups/nginx.conf
	print "nginx.conf backed up."

	cp importfiles/nginx.conf /etc/nginx/nginx.conf
	chmod 600 /etc/nginx/nginx.conf
	print "nginx.conf permissions configured."
	systemctl restart nginx >> $LOG
	print "nginx restarted with new configurations."
else
	systemctl stop nginx.service >> $LOG 2>>$LOG
	apt-get purge nginx nginx-full nginx-extras -y -qq >> $LOG
 	print "nginx removed."
fi
