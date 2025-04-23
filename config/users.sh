#!/bin/bash
LOG = ______
function print() {
  echo "$1" | sudo tee -a $LOG 
}
#Collect the users on the VM
USERS = ______
#Collect the user info given out by Cyberpatriot
print "Copy and paste the list of the authorized user/password list here:"
read givenuserlist
#Change all passwords (except for the one for yourself)

#Compare list of authorized users to the users on the VM. If one is found, append it to a list of usernames.
print "The following unauthorized users were found: ____"
print "Would you like to remove them?"
read removeunwantedusers
if [ $removeunwantedusers == "yes" ];
then

else
  print "The users will not be removed. (Also maybe invalid response)"
fi
#Remove admin from unauthorized users

#Give admin to authorized users

