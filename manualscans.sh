#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

print "Running scans and sending results to /scans/..."

print "Applications with hack or crack in the name (remove these):\n" >> /scans/hackcrack.txt
sudo dpkg -l | grep -E 'hack|crack' | tee $LOG >> /scans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

sudo ss -tulnp | tee $LOG > /scans/ss_-tulnp.txt
print "Ran ss -tulnp to scan listening ports."

sudo ps aux | tee $LOG > /scans/ps_aux.txt
print "Ran ps aux to see running processes."

sudo systemctl list-unit-files --type=service | tee $LOG > /scans/list-unit-files.txt
print "Ran systemctl list-unit-files to see all processes on the VM."

sudo lsof -i -P -n | tee $LOG > /scans/lsof.txt
print "Ran lsof to list all open network connections and the processes that opened them."

for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> /scans/PIDpaths.txt; 
    fi 
  done
print "Resolved all of the executible paths of PIDS in /scans/PIDpaths. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running."

sudo find / -type f -mtime -7 -print0 | xargs -0 ls -lt
#prints all files modified in the last 7 days

sudo find / -type f -perm /6000 -ls
#Finds SUID/SGID binaries. Misconfigured SUID/SGID binaries can be exploited for privilege escalation.
#Look for: Any SUID/SGID binaries that are not standard system binaries or are in unexpected locations.
sudo find / -type f -name ".*" -ls
#Finds hidden files. Malware often hides its components.
sudo cat /etc/hosts
#Check for any unusual entries that redirect legitimate traffic to malicious IPs.
sudo cat /etc/resolv.conf
#Check for suspicious DNS servers that could be redirecting traffic.

#Malware-Specific Tools:
#sudo apt install rkhunter and sudo rkhunter --check: Rootkit Hunter checks for rootkits, backdoors, and local exploits by comparing file hashes, looking for suspicious modules, and checking system configuration.
#sudo apt install chkrootkit and sudo chkrootkit: chkrootkit is another tool for detecting rootkits.
#ClamAV (Antivirus): sudo apt install clamav and then sudo freshclam (to update signatures) followed by sudo clamscan -r /home /var /tmp (to scan specific directories).
#Note: ClamAV is a signature-based AV, so it might not catch zero-day malware.


#Confirmation before continuting with other scripts
print "Have you reviewed the scans?"
read confirm
