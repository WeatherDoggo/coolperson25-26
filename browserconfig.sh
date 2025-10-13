#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

browser=""
while true; do
  print "Is Firefox or Chrome used on this computer?"
  read browser
  if [[ $browser == "chrome" || $browser == "Chrome" ]]; then
    browser="Chrome"
    print "Browser set to Chrome."
    apt-get purge firefox -y -qq
    apt-get purge brave-browser -y -qq
    apt-get purge opera-stable -y -qq
    apt-get purge microsoft-edge-stable -y -qq
    break
  elif [[ $browser == "Firefox" || $browser == "firefox" ]]; then
    browser="Firefox"
    print "Browser set to Firefox."
    apt-get purge google-chrome* -y -qq
    apt-get purge brave browser -y -qq
    apt-get purge opera-stable -y -qq
    apt-get purge microsoft-edge-stable -y -qq
    break
  elif [[ $browser == "skip" || $browser == "Skip" ]]; then
    print "Browser config skipped. Please config and remove browsers manually."
  else
    print "Browser not recognized. Please enter Firefox, Chrome, or skip."
  fi
done
