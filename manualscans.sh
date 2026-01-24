#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

mkdir ./scans/
chmod 777 ./scans/
mkdir ./scans/resources
chmod 777 ./scans/resources
print "Running scans and sending results to /scans/..."

print "Applications with hack, crack, or evil in the name:\n" > ./scans/hackcrack.txt
dpkg -l | grep -E 'hack|crack|evil' >> ./scans/hackcrack.txt
chmod 777 ./scans/hackcrack.txt
print "Apps with hack or crack have been scanned for."

#All Installed Apps
apt list --installed > ./scans/resources/aptapps.txt
chmod 777 ./scans/resources/aptapps.txt
print "apt installed apps listed in aptapps.txt."

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

print "PIDpaths"  > ./scans/resources/PIDpaths.txt
for pid in $(ls /proc | grep -E '^[0-9]+$'); do 
  if [ -e "/proc/$pid/exe" ];
    then print "PID: $pid, Command: $(readlink -f /proc/$pid/exe)" >> ./scans/resources/PIDpaths.txt
    fi 
  done
chmod 777 ./scans/resources/PIDpaths.txt
print "Resolved all of the executible paths of PIDS in PIDpaths.txt. Look for ones in /tmp, /dev/shm, or ones that have been deleted but are still running." >> ./scans/resources/PIDpaths.txt

#find / -type f -perm /6000 -ls > ./scans/binaryconfigs.txt
#chmod 777 ./scans/binaryconfigs.txt
#print "Listed all SUID/SGID binaries in binaryconfigs.txt to check for misconfiguration."
#print "Watch for the following:\nSetuid on scripts (.sh, .py, etc.)\nBinaries in user-writable paths like /tmp, /home, or /var/tmp\nBinaries with 777 permissions" >> ./scans/binaryconfigs.txt

find / -perm -u=s -type f 2>/dev/null > ./scans/suid.txt
chmod 777 ./scans/suid.txt
print "suid binaries listed in suid.txt."

cat /etc/hosts > ./scans/hostentries.txt
chmod 777 ./scans/hostentries.txt
print "Check for any unusual entries that redirect traffic to malicious IPs." >> ./scans/hostentries.txt

cat /etc/resolv.conf > ./scans/suspiciousDNS.txt
chmod 777 ./scans/suspiciousDNS.txt
print "Check for suspicious DNS servers that could be redirecting traffic." >> ./scans/suspiciousDNS.txt

crontab -l > ./scans/cronjobs.txt
#cat /etc/crontab /etc/cron.*/* > ./scans/cronjobs.txt
chmod 777 ./scans/cronjobs.txt
print "crontab jobs listed in scans/cronjobs.txt."

locate *.zip > ./scans/zippaths.txt
chmod 777 ./scans/zippaths.txt
print ".zip file paths listed in zippaths.txt."

mawk -F: '$3 < 1000 || $3 > 65533 {print $1, $3}' /etc/passwd > ./scans/strangeusers.txt
chmod 777 ./scans/strangeusers.txt
print "Strange UIDs listed in strangeusers.txt"

#Hidden Files
find / -type f -name ".*" > ./scans/resources/hiddenfiles.txt
chmod 777 ./scans/resources/hiddenfiles.txt
print "Hidden files listed in hiddenfiles.txt"

#Files without an owner
find / -xdev \( -nouser -o -nogroup \) -print > ./scans/filesnoowner.txt
chmod 777 ./scans/filesnoowner.txt
print "Files with no owning user/group listed in filesnoowner.txt"

#Insecure files and directories
find / -xdev -type f -perm -002 -ls > ./scans/writeablethings.txt
chmod 777 ./scans/writeablethings.txt
find / -xdev -type d -perm -002 -ls >> ./scans/writeablethings.txt
print "Files and directories that need securing have been stored in writeablethings.txt."

: > ./scans/kerneldesc.txt   # truncate output file
# Get each module name from /proc/modules
awk '{print $1}' /proc/modules | while read -r mod; do
    # Get filename and description (may be empty)
    fname=$(modinfo -F filename "$mod" 2>/dev/null)
    desc=$(modinfo -F description "$mod" 2>/dev/null)
    if echo "$desc" | grep -qi 'driver'; then
    	continue
    fi
    printf '%s\t%s\t%s\n' "$mod" "$desc" >> ./scans/kerneldesc.txt
done
echo "use dmesg | grep -i warning for warnings" >> ./scans/kerneldesc.txt
chmod 777 ./scans/kerneldesc.txt

: > ./scans/resources/kernelpaths.txt   # truncate output file
# Get each module name from /proc/modules
awk '{print $1}' /proc/modules | while read -r mod; do
    # Get filename and description (may be empty)
    fname=$(modinfo -F filename "$mod" 2>/dev/null)
    desc=$(modinfo -F description "$mod" 2>/dev/null)
    if echo "$desc" | grep -qi 'driver'; then
    	continue
    fi
printf '%s\t%s\t%s\n' "$mod" "$fname" >> ./scans/resources/kernelpaths.txt
done
chmod 777 ./scans/resources/kernelpaths.txt
print "kernel module filepaths and descriptions printed."
#diff files
#mkdir ./scans/diffs
#chmod 777 ./scans/diffs
#function filediff() {
#  diff -B -i ./scans/$1 ./logs/cleanscans/$1 > ./scans/diffs/diff$1
#  chmod 777 ./scans/diffs/diff$1
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
#filediff suid.txt
#print "diffs created for scans."

#Confirmation before continuting with other scripts
print "Have you reviewed the scans?"
read confirm
