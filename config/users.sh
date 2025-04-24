#!/bin/bash
LOG=""
function print() {
  echo "$1" | sudo tee -a $LOG 
}
#Collect the users on the VM
USERS=`cut -d':' -f1 /etc/passwd | grep -vE '^(root|bin|daemon|adm|lp|sync|shutdown|halt|mail|news|uucp|operator|games|gopher|ftp|nobody|dbus|systemd-bus-proxy|systemd-networkd|systemd-resolve|systemd-timesyncd|systemd-oomd|messagebus|colord|saned|pulse|avahi|cups|rtkit|speech-dispatcher|usbmuxd|dnsmasq|kernoops|systemd-journald|systemd-logind|uuidd|geoclue|gnome-initial-setup|gdm|systemd-machine-id-commit|nm-dispatcher|ModemManager|NetworkManager|polkitd|chrony|sshd|snapd|lxd)'`
print "Users found on VM: $USERS"
#Collect the user info given out by Cyberpatriot
print "Copy and paste the list of the authorized user/password list here:"
read givenuserlist
#Change all passwords (except for the one for yourself)

print "All other user's passwords have been changed."
#Compare list of authorized users to the users on the VM. If one is found, append it to a list of usernames.
print "The following unauthorized users were found: ____"
print "Would you like to remove them?"
read removeunwantedusers
if [ $removeunwantedusers == "yes" ];
then

else
  print "The users will not be removed (or invalid response)."
fi
#Remove admin from unauthorized users

#Give admin to authorized users

#Lock root account
#Check for UID 0 user
