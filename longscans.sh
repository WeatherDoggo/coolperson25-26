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
  echo -e "Summary of warnings:" >> scans/rkhunter.log
  grep -A 8 "Warning" /var/log/rkhunter.log >> scans/rkhunter.log

  print "Used Rootkit Hunter to check for rootkits, backdoors, and local exploits and saved results to scans/rkhunter.log."
else
  print "Skipped rkhunter."
fi
#It does this by comparing file hashes, looking for suspicious modules, and checking system configuration.

print "Do you want to run lynis?"
read lynisquery
if [[ "$lynisquery" == "yes" || "$lynisquery" == "y" ]]; then
  print "Installing lynis..."
  apt-get install lynis -y -qq >> $LOG

  print "Running a default system scan..."
  lynis audit system | sudo tee -a $LOG
else
  print "lynis skipped."
fi

print "Do you want to run AIDE?"
read aidequery
if [[ "$aidequery" == "yes" || "$aidequery" == "y" ]]; then
  print "Installing AIDE..."
  apt-get install aide -y -qq >> $LOG

  print "Running aideinit..."
  aideinit >> $LOG
else
  print "AIDE skipped."
fi

print "Do you want to run clamAV?"
read clamAVinstallquery
if [[ "$clamAVinstallquery" == "yes" || "$clamAVinstallquery" == "y" ]]; then
    print "Installing ClamAV..."
    apt-get install clamav clamav-daemon -y -qq >> $LOG

    print "Updating virus database..."
    systemctl stop clamav-freshclam || true
    freshclam

    print "Running full system scan (this may take a while)..."
    # Only print files that are suspicious/infected
    clamscan -r -i --bell / | tee ~/clamav-results.txt
    print "Scan complete. Any suspicious findings are shown above and saved to ~/clamav-results.txt"
else
    print "ClamAV skipped."
fi

