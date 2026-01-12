#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

mkdir ./standalonescans/
chmod 777 ./standalonescans/
print "Running scans and sending results to /standalonescans/..."

print "Applications with hack, crack, or evil in the name:\n" > ./standalonescans/hackcrack.txt
dpkg -l | grep -E 'hack|crack|evil' >> ./standalonescans/hackcrack.txt
chmod 777 ./standalonescans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

#All Installed Apps
apt list --installed > ./standalonescans/aptapps.txt
chmod 777 ./standalonescans/aptapps.txt
print "apt installed apps listed in aptapps.txt."

ss -tulnp > ./standalonescans/ss_-tulnp.txt
chmod 777 ./standalonescans/ss_-tulnp.txt
print "Ran ss -tulnp to scan listening ports."

ps aux > ./standalonescans/ps_aux.txt
chmod 777 ./standalonescans/ps_aux.txt
print "Ran ps aux to see running processes."

systemctl list-unit-files --type=service > ./standalonescans/list-unit-files.txt
chmod 777 ./standalonescans/list-unit-files.txt
print "Ran systemctl list-unit-files to see all processes on the VM."

lsof -i -P -n > ./standalonescans/lsof.txt
chmod 777 ./standalonescans/lsof.txt
print "Ran lsof to list all open network connections and the processes that opened them."

print "PIDpaths"  > ./standalonescans/PIDpaths.txt
for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> ./standalonescans/PIDpaths.txt
    fi 
  done
chmod 777 ./standalonescans/PIDpaths.txt
print "Resolved all of the executible paths of PIDS in PIDpaths.txt. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running." >> ./standalonescans/PIDpaths.txt

find / -type f -mtime -7 -print0 | xargs -0 ls -lt > ./standalonescans/modifiedfiles.txt
chmod 777 ./standalonescans/modifiedfiles.txt
print "Listed all files modified in the last 7 days."

find / -type f -perm /6000 -ls > ./standalonescans/binaryconfigs.txt
chmod 777 ./standalonescans/binaryconfigs.txt
print "Listed all SUID/SGID binaries in binaryconfigs.txt to check for misconfiguration."
print "Watch for the following:\nSetuid on scripts (.sh, .py, etc.)\nBinaries in user-writable paths like /tmp, /home, or /var/tmp\nBinaries with 777 permissions" >> ./standalonescans/binaryconfigs.txt

cat /etc/hosts > ./standalonescans/hostentries.txt
chmod 777 ./standalonescans/hostentries.txt
print "Check for any unusual entries that redirect traffic to malicious IPs." >> ./standalonescans/hostentries.txt

cat /etc/resolv.conf > ./standalonescans/suspiciousDNS.txt
chmod 777 ./standalonescans/suspiciousDNS.txt
print "Check for suspicious DNS servers that could be redirecting traffic." >> ./standalonescans/suspiciousDNS.txt

cat /etc/crontab > ./standalonescans/cronjobs.txt
chmod 777 ./standalonescans/cronjobs.txt
print "crontab jobs backed up in scans/cronjobs.txt."

locate *.zip > ./standalonescans/zippaths.txt
chmod 777 ./standalonescans/zippaths.txt
print ".zip file paths listed in zippaths.txt."

mawk -F: '$3 < 1000 || $3 > 65533 {print $1, $3}' /etc/passwd > ./standalonescans/strangeusers.txt
chmod 777 ./standalonescans/strangeusers.txt
print "Strange UIDs listed in strangeusers.txt"

find / -type f -name ".*" > ./standalonescans/hiddenfiles.txt
chmod 777 ./standalonescans/hiddenfiles.txt
print "Hidden files listed in hiddenfiles.txt"

#Files without an owner
find / -xdev \( -nouser -o -nogroup \) -print > ./standalonescans/filesnoowner.txt
chmod 777 ./standalonescans/filesnoowner.txt
print "Files with no owning user/group listed in filesnoowner.txt"

#Insecure files and directories
find / -xdev -type f -perm -002 -ls > ./standalonescans/writeablethings.txt
chmod 777 ./standalonescans/writeablethings.txt
find / -xdev -type d -perm -002 -ls >> ./standalonescans/writeablethings.txt
print "Files and directories that need securing have been stored in writeablethings.txt."
