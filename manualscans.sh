#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "Running scans and sending results to /scans/..."

print "Applications with hack or crack in the name (remove these):\n" > /scans/hackcrack.txt
dpkg -l | grep -E 'hack|crack' | sudo tee -a $LOG >> /scans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

ss -tulnp | sudo tee -a $LOG > /scans/ss_-tulnp.txt
print "Ran ss -tulnp to scan listening ports."

ps aux | sudo tee -a $LOG > /scans/ps_aux.txt
print "Ran ps aux to see running processes."

systemctl list-unit-files --type=service | sudo tee -a $LOG > /scans/list-unit-files.txt
print "Ran systemctl list-unit-files to see all processes on the VM."

lsof -i -P -n | sudo tee -a $LOG > /scans/lsof.txt
print "Ran lsof to list all open network connections and the processes that opened them."

print "PIDpaths" | sudo tee -a $LOG > /scans/PIDpaths.txt
for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> /scans/PIDpaths.txt; 
    fi 
  done
print "Resolved all of the executible paths of PIDS in PIDpaths.txt. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running."

find / -type f -mtime -7 -print0 | xargs -0 ls -lt | sudo tee -a $LOG > /scans/modifiedfiles.txt
print "Listed all files modified in the last 7 days."

find / -type f -perm /6000 -ls | sudo tee -a $LOG > /scans/binaryconfigs.txt
print "Listed all SUID/SGID binaries in binaryconfigs.txt to check for misconfiguration (privilege escalation)."
#Finds SUID/SGID binaries. Misconfigured SUID/SGID binaries can be exploited for privilege escalation.
#Look for: Any SUID/SGID binaries that are not standard system binaries or are in unexpected locations.

find / -type f -name ".*" -ls | sudo tee -a $LOG > /scans/hiddenfiles.txt
print "Listed all hidden files in /hiddenfiles.txt."
#Finds hidden files. Malware often hides its components.

cat /etc/hosts | sudo tee -a $LOG > /scans/hostentries.txt
#Check for any unusual entries that redirect legitimate traffic to malicious IPs.

cat /etc/resolv.conf | sudo tee -a $LOG > /scans/suspiciousDNS.txt
#Check for suspicious DNS servers that could be redirecting traffic.

#Malware-Specific Tools:
#apt-get install rkhunter and rkhunter --check: Rootkit Hunter checks for rootkits, backdoors, and local exploits by comparing file hashes, looking for suspicious modules, and checking system configuration.
#apt-get install chkrootkit and chkrootkit: chkrootkit is another tool for detecting rootkits.
#ClamAV: apt-get install clamav and then freshclam (to update signatures) followed by clamscan -r /home /var /tmp (to scan specific directories).

#Confirmation before continuting with other scripts
print "Have you reviewed the scans?"
read confirm
