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

  #Disable xdmcp in GDM (Remediation is applicable only in certain platforms)
  if dpkg-query --show --showformat='${db:Status-Status}' 'gdm3' 2>/dev/null | grep -q '^installed$'; then

    #Try find '[xdmcp]' and 'Enable' in '/etc/gdm3/custom.conf', if it exists, set to 'false', if it isn't here, add it, if '[xdmcp]' doesn't exist, add it there
    if grep -qzosP '[[:space:]]*\[xdmcp]([^\n\[]*\n+)+?[[:space:]]*Enable' '/etc/gdm3/custom.conf'; then
    
      sed -i "s/Enable[^(\n)]*/Enable=false/" '/etc/gdm3/custom.conf'
    elif grep -qs '[[:space:]]*\[xdmcp]' '/etc/gdm3/custom.conf'; then
      sed -i "/[[:space:]]*\[xdmcp]/a Enable=false" '/etc/gdm3/custom.conf'
    else
      if test -d "/etc/gdm3"; then
        printf '%s\n' '[xdmcp]' "Enable=false" >> '/etc/gdm3/custom.conf'
      else
        print "Config file directory '/etc/gdm3' doesnt exist, not remediating, assuming non-applicability." >&2
      fi
    fi

    else
    >&2 print 'Remediation is not applicable, nothing was done'
    fi


  dconf update
  #print "ADD A USER PROFILE FOR EACH!!!!"
  print "gdm & gdm3 custom.conf configured. More work to be done!!!!"
fi
