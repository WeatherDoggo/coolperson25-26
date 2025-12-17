#1/bin/bash
#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $postfixneeded == "yes" || $postfixneeded == "y" ]];
then
	print "CONFIGURE POSTFIX!!!!!!!!!!!!!!!!!"
else
  systemctl stop postfix
  apt-get purge postfix
  print "postfix mailserver removed."
fi
