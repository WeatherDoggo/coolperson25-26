#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

if [[ $OS == "mint" ]]; then
  print "Configure lightdm!"
elif [[ $OS == "ubuntu" ]]; then
  #mkdir -p /etc/dconf/
  #echo -e "1. Add/check that /etc/dconf/profile/ contains the following:\nuser-db:user\nsystem-db:{NAME_OF_DCONF_DATABASE}\n2. Create the directory /etc/dconf/db/local.d/ if it doesn't already exist\n 3. Create the key file /etc/dconf/db/local.d/00-screensaver to provide
#information for the local database; ex file in importfiles\nDid this need to be done?"
  #read GDMdatabase
  
  #print "you must logout and restart computer for changes to take effect."
  
  cp importfiles/custom.conf /etc/gdm/custom.conf
  cp importfiles/custom.conf /etc/gdm3/custom.conf

  #Screensaver
  #gsettings set org.gnome.desktop.screensaver lock-delay 5
  #gsettings set org.gnome.desktop.session idle-delay 300

  #Banner
  #gsettings set org.gnome.login-screen banner-message-text 'Authorized uses only. All activity may be monitored and reported'
  #gsettings set org.gnome.login-screen banner-message-enable true

  #Disable login user list
  #gsettings set org.gnome.login-screen disable-user-list true

  dconf update
  #print "ADD A USER PROFILE FOR EACH!!!!"
  print "gdm & gdm3 custom.conf configured. More work to be done!!!!"
fi
