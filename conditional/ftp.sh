#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $ftpneeded == "yes" || $ftpneeded == "y" ]];
then
	ufw allow ftp
	print "UFW configured for ftp."

	systemctl enable ftp
	systemctl restart ftp
	print "CONFIGURE FTP!!!!!!!!!!!!!!!!!"
else
	systemctl stop ftp.service >> $LOG 2>>$LOG
	apt-get purge ftp -y -qq >> $LOG
 	print "ftp removed."
fi
