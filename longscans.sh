#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#Rootkit checker:
print "Do you want to run rkhunter?"
read rkinstallqueury
if [[ $rkinstallqueury == "yes" || [[ $rkinstallqueury == "y" ]]; then
  apt-get install rkhunter -y -qq >> $LOG
  rkhunter --update | sudo tee -a $LOG > ./scans/rkhunter.txt
  rkhunter --propupd | sudo tee -a $LOG >> ./scans/rkhunter.txt
  rkhunter --check >> ./scans/rkhunter.txt 
  print "Used Rootkit Hunter to check for rootkits, backdoors, and local exploits and saved results to rkhunter.txt."
else
  print "Skipped rkhunter."
fi
#It does this by comparing file hashes, looking for suspicious modules, and checking system configuration.

print "Do you want to run clamAV?"
read clamAVinstallqueury
