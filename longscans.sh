#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}
mkdir -p scans
chmod 777 scans

#Rootkit checker:
print "Do you want to run rkhunter?"
read rkinstallqueury
if [[ "$rkinstallqueury" == "yes" || "$rkinstallqueury" == "y" ]]; then
  apt-get install rkhunter -y
  cp importfiles/rkhunter.conf /etc/rkhunter.conf
  print "rkhunter conf copied."
  rkhunter --config-check
  rkhunter --update
  rkhunter --propupd
  rkhunter --check
  cp /var/log/rkhunter.log scans/rkhunter.log
  chmod 777 scans/rkhunter.log
  echo -e "Summary of warnings:" >> /scans/rkhunter.log
  grep -A 5 "Warning" /var/log/rkhunter.log >> /scans/rkhunter.log

  print "Used Rootkit Hunter to check for rootkits, backdoors, and local exploits and saved results to scans/rkhunter.log."
else
  print "Skipped rkhunter."
fi
#It does this by comparing file hashes, looking for suspicious modules, and checking system configuration.

print "Do you want to run clamAV?"
read clamAVinstallqueury

print "Do you want to run debsums?"

