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
chmod 777 ./scans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

ss -tulnp > ./scans/ss_-tulnp.txt
chmod 777 ./scans/ss_-tulnp.txt
print "Ran ss -tulnp to scan listening ports."

ps aux > ./scans/ps_aux.txt
chmod 777 ./scans/ps_aux.txt
print "Ran ps aux to see running processes."

systemctl list-unit-files --type=service > ./scans/list-unit-files.txt
chmod 777 ./scans/list-unit-files.txt
print "Ran systemctl list-unit-files to see all processes on the VM."

lsof -i -P -n > ./scans/lsof.txt
chmod 777 ./scans/lsof.txt
print "Ran lsof to list all open network connections and the processes that opened them."

print "PIDpaths"  > ./scans/PIDpaths.txt
for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> ./scans/PIDpaths.txt
    fi 
  done
chmod 777 ./scans/PIDpaths.txt
print "Resolved all of the executible paths of PIDS in PIDpaths.txt. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running." >> ./scans/PIDpaths.txt

find / -type f -perm /6000 -ls > ./scans/binaryconfigs.txt
chmod 777 ./scans/binaryconfigs.txt
print "Listed all SUID/SGID binaries in binaryconfigs.txt to check for misconfiguration."
print "Watch for the following:\nSetuid on scripts (.sh, .py, etc.)\nBinaries in user-writable paths like /tmp, /home, or /var/tmp\nBinaries with 777 permissions" >> ./scans/binaryconfigs.txt

cat /etc/hosts > ./scans/hostentries.txt
chmod 777 ./scans/hostentries.txt
print "Check for any unusual entries that redirect traffic to malicious IPs." >> ./scans/hostentries.txt

cat /etc/resolv.conf > ./scans/suspiciousDNS.txt
chmod 777 ./scans/suspiciousDNS.txt
print "Check for suspicious DNS servers that could be redirecting traffic." >> ./scans/suspiciousDNS.txt

crontab -l > ./scans/cronjobs.txt
chmod 777 ./scans/cronjobs.txt
print "crontab jobs backed up in scans/cronjobs.txt."

#Confirmation before continuting with other scripts
print "Have you reviewed the scans?"
read confirm
