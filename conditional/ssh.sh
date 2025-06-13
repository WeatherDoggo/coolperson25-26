#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $sshneeded == "yes" || $sshneeded == "y" ]];
then
	cp importfiles/sshd_config /etc/ssh/sshd_config
	chmod u-x,og-rwx /etc/ssh/sshd_config
	chown root:root /etc/ssh/sshd_config
	print "sshd_config permissions configured."
 	systemctl restart sshd >> $LOG
  print "SSH restarted."
	print "SSH default port changed, PermitRootLogin set to no, MaxAuthTries set to 3, Client closes after 4 minutes inactive, LoginGraceTime set to 20, PermitEmptyPasswords is set to no, HostBasedAuthentication set to no, and StrictModes is set to yes."
 	#Optional SSH tasks include MaxSessions, TCPKeepAlive, & changing default port.
else
	apt-get purge openssh-server openssh-client -y -qq >> $LOG
	ufw deny ssh >> $LOG
	print "SSH removed and SSH port closed."
fi
