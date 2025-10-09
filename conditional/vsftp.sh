#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $vsftpneeded == "yes" || $vsftpneeded == "y" ]];
then
	#cp /etc/nginx/nginx.conf ../backups/nginx.conf
	#chmod 777 ../backups/nginx.conf
	#print "nginx.conf backed up."

	systemctl enable vsftpd
	systemctl restart vsftpd
	#cp importfiles/nginx.conf /etc/nginx/nginx.conf
	#chown root:root /etc/nginx/nginx.conf >> $LOG
	#chmod 600 /etc/nginx/nginx.conf >> $LOG
	#print "nginx.conf configured."
	#systemctl reload nginx >> $LOG
	#print "nginx restarted with new configurations."
else
	systemctl stop vsftpd.service >> $LOG 2>>$LOG
	apt-get purge vsftpd -y -qq >> $LOG
	systemctl stop ftp.service >> $LOG 2>>$LOG
	apt-get purge ftp -y -qq >> $LOG
 	print "ftp & vsftpd removed."
fi
