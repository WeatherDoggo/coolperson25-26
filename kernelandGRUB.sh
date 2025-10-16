#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "In /etc/grub.d/40_custom, set check_signatures=enforce"

#enable Kernel ExecShield
sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/{
  /exec-shield=1/! s/"$/ exec-shield=1"/
}' /etc/default/grub

#enable Kernel Lockdown
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 lockdown=confidentiality\"/" /etc/default/grub

#Disable system core dumps
cp ./importfiles/limits.conf /etc/security/limits.conf
print "Core dumps disabled and limit of 2000 processes set with limits.conf."

update-grub
