#!/bin/bash
cp /etc/nginx/nginx.conf $BACKUPDIR/nginx.conf
chmod 777 $BACKUPDIR/nginx.conf
print "nginx.conf backed up."
cp importfiles/nginx.conf /etc/nginx/nginx.conf
chmod 600 /etc/nginx/nginx.conf
print "nginx.conf permissions configured."
echo "... (add more stuff)"

elif [[ $nginx == "no" || $nginx == "n" ]];
then
	systemctl stop nginx.service >> $LOG_FILE 2>>$LOG_FILE
	apt-get purge nginx nginx-full nginx-extras -y -qq >> $LOG_FILE
 	printlog "nginx removed."
