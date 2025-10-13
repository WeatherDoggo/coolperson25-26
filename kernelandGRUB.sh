#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}



#enable Kernel ExecShield
sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/{
  /exec-shield=1/! s/"$/ exec-shield=1"/
}' /etc/default/grub
update-grub
