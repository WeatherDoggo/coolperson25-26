#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $apache2needed == "yes" || $apache2needed == "y" ]];
then
	ufw allow http >> $LOG
	ufw allow https >> $LOG
	print "HTTP and HTTPS ports opened."
	
	cp /etc/apache2/apache2.conf ../backups/apache2.conf
	chmod 777 ../backups/apache2.conf
	print "apache2.conf backed up."
	
	cp importfiles/apache2.conf /etc/apache2/apache2.conf
	chown root:root /etc/apache2/apache2.conf >> $LOG
	chmod 644 /etc/apache2/apache2.conf >> $LOG
	print "apache2.conf ownership and permissions set."

	ufw allow 'Apache Secure'
	print "ufw configured for apache."
	
	a2enmod headers
	systemctl enable apache2
	systemctl restart apache2
	print "apache2.conf configured and restarted."
else
	systemctl stop apache2.socket apache2.service >> $LOG 2>>$LOG
	apt-get purge apache2 -y -qq >> $LOG
	print "apache2 removed."
fi
