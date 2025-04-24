#!/bin/bash
#Collect the users on the VM, and exclude the one i'm not supposed to edit.
print "What is your username?"
read myusername
vmusers=`(cut -d':' -f1,6 /etc/passwd | grep '/home/' | cut -d':' -f1 | grep -vE "^${myusername}")`
echo -e "Users found on VM:\n$vmusers" | sudo tee -a $LOG

#Collect the user info given out by Cyberpatriot
print "Copy and paste the list of the authorized user/password list here, then press Ctrl + D:"
givenuserlist=$(cat)

authadmins=()
authusers=()
admin_section=0
user_section=0

while IFS= read -r line; do
  line=$(echo "$line" | tr -d '[:space:]') # Remove leading/trailing whitespace

  # Skip lines containing "password" (case-insensitive)
  if [[ "$(echo "$line" | grep -iq 'password')" ]]; then
    continue
  fi

  # Case-insensitive check for "administrator" in the line
  if [[ "$(echo "$line" | grep -io 'administrator')" ]]; then
    admin_section=1
    user_section=0
    continue
  # Case-insensitive check for "user" in the line
  elif [[ "$(echo "$line" | grep -io 'user')" ]]; then
    user_section=1
    admin_section=0
    continue
  fi

  if [[ $admin_section -eq 1 ]]; then
    # Stop processing admin users when we reach the "Authorized Users:" header
    if [[ "$(echo "$line" | grep -io 'user')" ]]; then
      admin_section=0
      user_section=1
      continue
    fi
    # If the line is not empty and not containing $myusername
    if [[ -n "$line" ]] && [[ ! "$line" == *"$myusername"* ]]; then
      authadmins+=("$line")
    fi
  elif [[ $user_section -eq 1 ]]; then
    if [[ -n "$line" ]] && [[ ! "$line" == *"$myusername"* ]]; then
      authusers+=("$line")
    fi
  fi
done <<< "$givenuserlist"
print ""
print "Authorized Administrators: ${authadmins[*]}"
#print "Authorized Users: ${authusers[*]}"

#Compare list of authorized users to the users on the VM. If one is found, append it to a list of usernames.

#Change all passwords (except for the one for yourself)

#Remove admin from unauthorized users

#Give admin to authorized users


#Set UID & GID 0 to root
#usermod -u 0 root
#usermod -g 0 root
#groupmod -g 0 root
#printlog "UID & GID for root set to 0."

#Lock root account
#passwd -l root >> $LOG
#print "Root account locked."
