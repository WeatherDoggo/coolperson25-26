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
    break
  elif [[ $browser == "Firefox" || $browser == "firefox" ]]; then
    browser="Firefox"
    print "Browser set to Firefox."
    rm -rf ~/.mozilla/firefox/*.default-release
    echo 'user_pref("dom.security.https_only_mode", true);' >> ~/.mozilla/firefox/*.default-release/user.js
    print "Settings reset to default, HTTPS-only mode has been enabled."
    break
  elif [[ $browser == "skip" || $browser == "Skip" ]]; then
    print "Browser config skipped. Please config browser manually."
  else
    print "Browser not recognized. Please enter Firefox, Chrome, or skip."
  fi
done
