#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $phpneeded == "yes" || $phpneeded == "y" ]];
then
	print "CONFIGURE PHP!!!!!!!!!!!!!!!!!"
else
  systemctl stop php
  apt-get purge php -y -qq >> $LOG
  print "php removed."
fi
