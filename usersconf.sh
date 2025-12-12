#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#Set UID & GID 0 to root
usermod -u 0 root
usermod -g 0 root
groupmod -g 0 root
print "UID & GID for root set to 0."

#Collect the users on the VM, and exclude the one i'm not supposed to edit.
print "What is your username?"
read myusername
vmusers=`(grep -v 'nologin' /etc/passwd | cut -d':' -f1,6 | grep 'home' | cut -d':' -f1 | grep -v "${myusername}")`
print "\nUsers found on VM:\n$vmusers"
print "Any users like syslog should be nologin! (sudo usermod -s /sbin/nologin <username>)"

#Collect the user info given out by Cyberpatriot
print "Copy and paste the list of the authorized admin user/password list here, then press Ctrl + D:"
givenadminlist=$(cat)
print "\nNow copy and paste the list of the authorized user list here, then press Ctrl + D:"
givenuserlist=$(cat)
authadmins=()
authusers=()

#For the admins list:
IFS=$'\n' read -r -d '' -a admin_lines <<< "$givenadminlist"
for line in "${admin_lines[@]}"; do
  if [[ "$line" != *"password"* ]]; then #Removes password lines
    username=$(echo "$line" | awk '{print $1}')
    if [[ "$username" != "$myusername" ]]; then #Removes myusername from list
      authadmins+=("$username")
      authusers+=("$username")
    fi
  fi
done

#For the users list:
IFS=$'\n' read -r -d '' -a user_lines <<< "$givenuserlist"
for user in "${user_lines[@]}"; do
  if [[ "$user" != "$myusername" ]]; then
    # Check if the user is not already in authusers (from the admin list)
    is_admin=false
    for admin in "${authadmins[@]}"; do
      if [[ "$user" == "$admin" ]]; then
        is_admin=true
        break
      fi
    done
    if [[ "$is_admin" == false ]]; then
      authusers+=("$user")
    fi
  fi
done
print "\nAuthorized Administrators: ${authadmins[*]}"
print "\nAuthorized Users: ${authusers[*]}"

#Compare list of authorized users to the users on the VM. If one is found, append it to a list of usernames.
IFS=$'\n' read -r -d '' -a vm_user_array <<< "$vmusers"
userstoremove=()

for vm_user in "${vm_user_array[@]}"; do
  found=false
  for authorized_user in "${authusers[@]}"; do
    if [[ "$vm_user" == "$authorized_user" ]]; then
      found=true
      break
    fi
  done
  if [[ "$found" == false ]]; then
    userstoremove+=("$vm_user")
  fi
done

if [[ ${#userstoremove[@]} -gt 0 ]]; then   #<<<Random pound sign???
  print "\nThe following users are present on the VM but are NOT on the provided authorized user list:"
  for user in "${userstoremove[@]}"; do
    print "- $user"
  done
  for user in "${userstoremove[@]}"; do
    print "Should $user be removed?"
    read removestrangeuser
    if [[ "$removestrangeuser" == "y" || "$removestrangeuser" == "yes" ]]; then
      print "Attempting to remove $user:"
      userdel -r "$user"
      if [ $? -eq 0 ]; then
        print "Successfully removed $user"
      else
        print "Failed to remove $user"
      fi
    else
      print "User skipped."
    fi
  done
  print "Selected users removed."
else
  print "All users found on the VM are present on the provided authorized user list."
fi

#Refresh vmusers
vmusers=`(grep -v 'nologin' /etc/passwd | cut -d':' -f1,6 | grep 'home' | cut -d':' -f1 | grep -v "${myusername}")`

#Change all passwords (except for the one for yourself)
newpassword="Cyb3r1a!Cyb3r1a!"
for user in $vmusers; do
    print "Changing password for $user:"
    # Use chpasswd to set the password
    # The 'echo' command pipes the username:password to chpasswd
    print "$user:$newpassword" | sudo chpasswd
    if [ $? -eq 0 ]; then
        print "Password for $user changed."
    else
        print "Failed to change password for $user."
    fi
    chage -m 7 $user
    print "Minimum password age set for $user."
    chage -M 90 $user
    print "Maximum password age set for $user."
done

#Remove admin from unauthorized users
print "Checking for unauthorized admins to remove from admin..."
for user in $vmusers; do
  if id -nG "$user" | grep -qw "sudo"; then
    is_auth_admin=false
    for authadmin in "${authadmins[@]}"; do
      if [[ "$user" == "$authadmin" ]]; then
        is_auth_admin=true
        break
      fi
    done
    if [[ "$is_auth_admin" == false ]]; then
      print "Removing $user's sudo access..."
      deluser "$user" sudo
    fi
  fi
done

#Give admin to authorized users
print "Adding authorized admins to the sudo group..."
for user in "${authadmins[@]}"; do
  if id -nG "$user" | grep -qw "sudo"; then
    print "$user is already an admin."
  else
    print "Adding $user to sudo & adm group..."
    usermod -aG sudo "$user"
    usermod -aG adm "$user"
  fi
done

#disable account identifiers after 30 days of password expiration
useradd -D -f 30 >> $LOG

#Lock root account
passwd -l root >> $LOG
print "Root account locked."

echo "TMOUT=600" | sudo tee -a /etc/profile
print "Idle users will be logged out."
