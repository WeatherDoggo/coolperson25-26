#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

mkdir ./standalonestandalonescans/
chmod 777 ./standalonestandalonescans/
print "Running standalonescans and sending results to /standalonestandalonescans/..."

print "Applications with hack, crack, or evil in the name:\n" > ./standalonestandalonescans/hackcrack.txt
dpkg -l | grep -E 'hack|crack|evil' >> ./standalonestandalonescans/hackcrack.txt
chmod 777 ./standalonestandalonescans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

#All Installed Apps
apt list --installed > ./standalonestandalonescans/aptapps.txt
chmod 777 ./standalonestandalonescans/aptapps.txt
print "apt installed apps listed in aptapps.txt."

ss -tulnp > ./standalonestandalonescans/ss_-tulnp.txt
chmod 777 ./standalonestandalonescans/ss_-tulnp.txt
print "Ran ss -tulnp to scan listening ports."

ps aux > ./standalonestandalonescans/ps_aux.txt
chmod 777 ./standalonestandalonescans/ps_aux.txt
print "Ran ps aux to see running processes."

systemctl list-unit-files --type=service > ./standalonestandalonescans/list-unit-files.txt
chmod 777 ./standalonestandalonescans/list-unit-files.txt
print "Ran systemctl list-unit-files to see all processes on the VM."

lsof -i -P -n > ./standalonestandalonescans/lsof.txt
chmod 777 ./standalonestandalonescans/lsof.txt
print "Ran lsof to list all open network connections and the processes that opened them."

print "PIDpaths"  > ./standalonestandalonescans/PIDpaths.txt
for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> ./standalonestandalonescans/PIDpaths.txt
    fi 
  done
chmod 777 ./standalonestandalonescans/PIDpaths.txt
print "Resolved all of the executible paths of PIDS in PIDpaths.txt. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running." >> ./standalonestandalonescans/PIDpaths.txt

find / -type f -mtime -7 -print0 | xargs -0 ls -lt > ./standalonestandalonescans/modifiedfiles.txt
chmod 777 ./standalonestandalonescans/modifiedfiles.txt
print "Listed all files modified in the last 7 days."

#find / -type f -perm /6000 -ls > ./standalonestandalonescans/binaryconfigs.txt
#chmod 777 ./standalonestandalonescans/binaryconfigs.txt
#print "Listed all SUID/SGID binaries in binaryconfigs.txt to check for misconfiguration."
#print "Watch for the following:\nSetuid on scripts (.sh, .py, etc.)\nBinaries in user-writable paths like /tmp, /home, or /var/tmp\nBinaries with 777 permissions" >> ./standalonestandalonescans/binaryconfigs.txt

find / -perm -u=s -type f 2>/dev/null > ./standalonestandalonescans/suid.txt
chmod 777 ./standalonestandalonescans/suid.txt
print "suid binaries listed in suid.txt."

cat /etc/hosts > ./standalonestandalonescans/hostentries.txt
chmod 777 ./standalonestandalonescans/hostentries.txt
print "Check for any unusual entries that redirect traffic to malicious IPs." >> ./standalonestandalonescans/hostentries.txt

cat /etc/resolv.conf > ./standalonestandalonescans/suspiciousDNS.txt
chmod 777 ./standalonestandalonescans/suspiciousDNS.txt
print "Check for suspicious DNS servers that could be redirecting traffic." >> ./standalonestandalonescans/suspiciousDNS.txt

cat /etc/crontab > ./standalonestandalonescans/cronjobs.txt
chmod 777 ./standalonestandalonescans/cronjobs.txt
print "crontab jobs backed up in standalonescans/cronjobs.txt."

locate *.zip > ./standalonestandalonescans/zippaths.txt
chmod 777 ./standalonestandalonescans/zippaths.txt
print ".zip file paths listed in zippaths.txt."

mawk -F: '$3 < 1000 || $3 > 65533 {print $1, $3}' /etc/passwd > ./standalonestandalonescans/strangeusers.txt
chmod 777 ./standalonestandalonescans/strangeusers.txt
print "Strange UIDs listed in strangeusers.txt"

find / -type f -name ".*" > ./standalonestandalonescans/hiddenfiles.txt
chmod 777 ./standalonestandalonescans/hiddenfiles.txt
print "Hidden files listed in hiddenfiles.txt"

#Files without an owner
find / -xdev \( -nouser -o -nogroup \) -print > ./standalonestandalonescans/filesnoowner.txt
chmod 777 ./standalonestandalonescans/filesnoowner.txt
print "Files with no owning user/group listed in filesnoowner.txt"

#Insecure files and directories
find / -xdev -type f -perm -002 -ls > ./standalonestandalonescans/writeablethings.txt
chmod 777 ./standalonestandalonescans/writeablethings.txt
find / -xdev -type d -perm -002 -ls >> ./standalonestandalonescans/writeablethings.txt
print "Files and directories that need securing have been stored in writeablethings.txt."


: > ./standalonescans/kerneldesc.txt   # truncate output file
# Get each module name from /proc/modules
awk '{print $1}' /proc/modules | while read -r mod; do
    # Get filename and description (may be empty)
    fname=$(modinfo -F filename "$mod" 2>/dev/null)
    desc=$(modinfo -F description "$mod" 2>/dev/null)
    if echo "$desc" | grep -qi 'driver'; then
    	continue
    fi
    printf '%s\t%s\t%s\n' "$mod" "$desc" >> ./standalonescans/kerneldesc.txt
done
chmod 777 ./standalonescans/kerneldesc.txt

: > ./standalonescans/resources/kernelpaths.txt   # truncate output file
# Get each module name from /proc/modules
awk '{print $1}' /proc/modules | while read -r mod; do
    # Get filename and description (may be empty)
    fname=$(modinfo -F filename "$mod" 2>/dev/null)
    desc=$(modinfo -F description "$mod" 2>/dev/null)
    if echo "$desc" | grep -qi 'driver'; then
    	continue
    fi
printf '%s\t%s\t%s\n' "$mod" "$fname" >> ./standalonescans/resources/kernelpaths.txt
done
chmod 777 ./standalonescans/resources/kernelpaths.txt
print "kernel module filepaths and descriptions printed."

#diff files
#mkdir ./standalonestandalonescans/diffs
#chmod 777 ./standalonestandalonescans/diffs
#function filediff() {
#  diff -B -i ./standalonestandalonescans/$1 ./logs/cleanstandalonescans/$1 > ./standalonestandalonescans/diffs/diff$1
#  chmod 777 ./standalonestandalonescans/diffs/diff$1
#}
#filediff PIDpaths.txt
#filediff aptapps.txt
#filediff binaryconfigs.txt
#filediff cronjobs.txt
#filediff filesnoowner.txt
#filediff hackcrack.txt
#filediff hiddenfiles.txt
#filediff hostentries.txt
#filediff list-unit-files.txt
#filediff lsof.txt
#filediff ps_aux.txt
#filediff ss_-tulnp.txt
#filediff strangeusers.txt
#filediff suspiciousDNS.txt
#filediff writeablethings.txt
#filediff zippaths.txt
#print "diffs created for standalonescans."
