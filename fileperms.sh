#!/bin/bash

chmod 640 /etc/shadow >> $LOG
print "/etc/shadow permissions configured."

chmod 600 /etc/sysctl.conf >> $LOG
print "sysctl.conf permissions configured."
