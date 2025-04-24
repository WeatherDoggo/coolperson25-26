#!/bin/bash
#Collect the users on the VM, and exclude the one i'm not supposed to edit.
print "What is your username?"
read myusername
vmusers=`(cut -d':' -f1,6 /etc/passwd | grep '/home/' | cut -d':' -f1 | grep -vE "^${myusername}")`
echo -e "Users found on VM:\n$vmusers" | sudo tee -a $LOG

#Collect the user info given out by Cyberpatriot
print "Copy and paste the list of the authorized user/password list here:"
read givenuserlist
authadmins=``
authusers=``
#Compare list of authorized users to the users on the VM. If one is found, append it to a list of usernames.
print "The following unauthorized users were found: ____"
print "Would you like to remove them?"
read removeunwantedusers
if [ $removeunwantedusers == "yes" ];
then

else
  print "The users will not be removed (or invalid response)."
fi
#Change all passwords (except for the one for yourself)

#Remove admin from unauthorized users

#Give admin to authorized users


#Set UID & GID 0 to root
usermod -u 0 root
usermod -g 0 root
groupmod -g 0 root
printlog "UID & GID for root set to 0."

#Lock root account
passwd -l root >> $LOG
print "Root account locked."
