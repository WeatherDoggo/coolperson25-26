#!/bin/bash
LOG=./logs/main.log
function print() {
  echo "$1" | sudo tee -a $LOG 
}

#Strange User IDs
print "Check for strange users:"
mawk -F: '$3 < 1000 || $3 > 65533 {print $1, $3}' /etc/passwd >> $LOG

print "COMPLETE THE TASKS ON THE CHECKLIST!"
read confirm
