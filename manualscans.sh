#!/bin/bash



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

#Confirmation before continuting with other scripts
print "Have you reviewed the scans?"
read confirm
