#!/bin/bash
LOG=.mylog
function print() {
  echo -e "$1" | sudo tee -a $LOG 
}



#Collect the users on the VM, and exclude the one i'm not supposed to edit.
print "What is your username?"
read myusername
vmusers=`(grep -v 'nologin' /etc/passwd | cut -d':' -f1,6 | grep 'home' | cut -d':' -f1 | grep -v "${myusername}")`
echo -e "Users found on VM:\n$vmusers" | sudo tee -a $LOG

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
print "Authorized Users: ${authusers[*]}"

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

if [[ ${userstoremove[@]} -gt 0 ]]; then
  print "The following users are present on the VM but are NOT on the provided authorized user list:"
  for user in "${userstoremove[@]}"; do
    print "- $user"
  done
else
  print "All users found on the VM are present on the provided authorized user list."
fi
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
