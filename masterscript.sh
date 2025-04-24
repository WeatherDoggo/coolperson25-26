#!/bin/bash
LOG = log
function print() {
  echo "$1" | sudo tee -a $LOG 
}
print "HAS UPDATE, UPGRADE, & AUTOREMOVE BEEN RUN?"
read runconfirm
if [[ $runconfirm == "yes" || $runconfirm == "y" ]];
then
  print "Proceeding..."
else
  print "Exiting..."
  exit
fi
