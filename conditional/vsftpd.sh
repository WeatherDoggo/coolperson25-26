#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $vsftpdneeded == "yes" || $vsftpdneeded == "y" ]];
then
	cp /etc/vsftpd.conf ../backups/vsftpd.conf
	chmod 777 ../backups/vsftpd.conf
	print "vsftpd.conf backed up."

	cp importfiles/vsftpd.conf /etc/vsftpd.conf
	chown root:root /etc/vsftpd.conf >> $LOG
	chmod 600 /etc/vsftpd.conf >> $LOG
	print "vsftpd.conf configured."
	systemctl enable vsftpd
	systemctl start vsftpd
	systemctl restart vsftpd
	print "vsftpd.conf restarted."

	ufw allow vsftpd
	print "UFW configured."
else
	systemctl stop vsftpd.service >> $LOG 2>>$LOG
	apt-get purge vsftpd -y -qq >> $LOG
 	print "vsftpd removed."
fi
