#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

mkdir ./scans2/
chmod 777 ./scans2/
print "Running scans and sending results to /scans2/..."

print "Applications with hack, crack, or evil in the name:\n" > ./scans/hackcrack.txt
dpkg -l | grep -E 'hack|crack|evil' >> ./scans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

ss -tulnp > ./scans2/ss_-tulnp.txt
print "Ran ss -tulnp to scan listening ports."

ps aux > ./scans2/ps_aux.txt
print "Ran ps aux to see running processes."

systemctl list-unit-files --type=service > ./scans2/list-unit-files.txt
print "Ran systemctl list-unit-files to see all processes on the VM."

lsof -i -P -n > ./scans2/lsof.txt
print "Ran lsof to list all open network connections and the processes that opened them."

print "PIDpaths"  > ./scans2/PIDpaths.txt
for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> ./scans2/PIDpaths.txt
    fi 
  done
print "Resolved all of the executible paths of PIDS in PIDpaths.txt. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running." >> ./scans2/PIDpaths.txt

find / -type f -mtime -7 -print0 | xargs -0 ls -lt > ./scans2/modifiedfiles.txt
print "Listed all files modified in the last 7 days."

find / -type f -perm /6000 -ls > ./scans2/binaryconfigs.txt
print "Listed all SUID/SGID binaries in binaryconfigs.txt to check for misconfiguration."
print "Watch for the following:\nSetuid on scripts (.sh, .py, etc.)\nBinaries in user-writable paths like /tmp, /home, or /var/tmp\nBinaries with 777 permissions" >> ./scans2/binaryconfigs.txt

cat /etc/hosts > ./scans2/hostentries.txt
print "Check for any unusual entries that redirect traffic to malicious IPs." >> ./scans2/hostentries.txt

cat /etc/resolv.conf > ./scans2/suspiciousDNS.txt
print "Check for suspicious DNS servers that could be redirecting traffic." >> ./scans2/suspiciousDNS.txt

crontab -l > ./scans2/cronjobs.txt
print "crontab jobs backed up in scans2/cronjobs.txt."
