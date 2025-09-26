#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

mkdir ./scans/
chmod 777 ./scans/
print "Running scans and sending results to /scans/..."

print "Applications with hack or crack in the name (remove these):\n" > ./scans/hackcrack.txt
dpkg -l | grep -E 'hack|crack' >> ./scans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

ss -tulnp > ./scans/ss_-tulnp.txt
print "Ran ss -tulnp to scan listening ports."

ps aux > ./scans/ps_aux.txt
print "Ran ps aux to see running processes."

systemctl list-unit-files --type=service > ./scans/list-unit-files.txt
print "Ran systemctl list-unit-files to see all processes on the VM."

#grep -vxFf ____________________
#./scans/list-unit-files.txt
#importfiles/default_unit_files

lsof -i -P -n > ./scans/lsof.txt
print "Ran lsof to list all open network connections and the processes that opened them."

print "PIDpaths"  > ./scans/PIDpaths.txt
for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> ./scans/PIDpaths.txt
    fi 
  done
print "Resolved all of the executible paths of PIDS in PIDpaths.txt. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running." >> ./scans/PIDpaths.txt

find / -type f -mtime -7 -print0 | xargs -0 ls -lt > ./scans/modifiedfiles.txt
print "Listed all files modified in the last 7 days."

find / -type f -perm /6000 -ls > ./scans/binaryconfigs.txt
print "Listed all SUID/SGID binaries in binaryconfigs.txt to check for misconfiguration."
print "Watch for the following:\nSetuid on scripts (.sh, .py, etc.)\nBinaries in user-writable paths like /tmp, /home, or /var/tmp\nBinaries with 777 permissions" >> ./scans/binaryconfigs.txt

cat /etc/hosts > ./scans/hostentries.txt
print "Check for any unusual entries that redirect traffic to malicious IPs." >> ./scans/hostentries.txt

cat /etc/resolv.conf > ./scans/suspiciousDNS.txt
print "Check for suspicious DNS servers that could be redirecting traffic." >> ./scans/suspiciousDNS.txt

crontab -l > ./scans/cronjobs.txt
print "crontab jobs backed up in scans/cronjobs.txt."

#Confirmation before continuting with other scripts
print "Have you reviewed the scans?"
read confirm
