#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $sambaneeded == "yes" || $sambaneeded == "y" ]];
then
	cp /etc/samba/smb.conf ../backups/smb.conf
	cp importfiles/smb.conf /etc/samba/smb.conf
	systemctl status smbd.service
	print "samba configured with smb.conf."
else
	systemctl stop samba.service >> $LOG 2>>$LOG
	systemctl stop smbd.service >> $LOG 2>>$LOG
	apt-get purge samba* smbd -y -qq >> $LOG
 	print "samba removed."
fi
