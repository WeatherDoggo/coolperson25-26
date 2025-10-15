#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}
print "What is your username?"
read USERNAME

#OS-Specific Changed
if [[ $OS == ubuntu ]]; then
#Automatic Updates


#Automatic screen lock enabled

#	print "Automatic screen lock has been enabled."

#Screen timeout policy

#	print "Screen timeout policy set to 4 minutes."

#else #Mint 21
#	print "DO THE AUTOMATIC UPDATES MANUALLY!!!"
fi

#sysctl.conf
cp ./importfiles/sysctl.conf /etc/sysctl.conf
sysctl -w net.ipv4.route.flush=1

apt-get install auditd audispd-plugins -y -qq
systemctl enable auditd
systemctl start auditd
cp ./importfiles/auditd.conf /etc/audit/auditd.conf
print "auditd installed, enabled, configured. More work to be done here!!!!"
systemctl restart auditd

sysctl --system
sysctl -p
sudo systemctl daemon-reload
print "sysctl.conf configured."

#/etc/shells config
sed -i '/nologin/c\\' /etc/shells
print "instances of nologin removed from /etc/shells."

#Disable Ctrl+Alt+Delete Reboot
echo "exec true" >> /etc/init/control-alt-delete.override
print "Ctrl+Alt+Delete reboot disabled."

touch /etc/cron.allow
touch /etc/cron.deny
chown root:root /etc/cron.allow
chmod og-rwx /etc/cron.allow
chown root:root /etc/cron.deny
chmod og-rwx /etc/cron.deny
chmod 600 /etc/cron.allow
chmod 600 /etc/cron.deny
chmod 700 /var/spool/cron/crontabs
print "Cron.deny & cron.allow created and limited if they didn't exist."

#Remove startup tasks from crontab
crontab -r >> $LOG
print "Root crontab scheduled jobs removed with crontab -r."

#Visudo
cp /etc/sudoers ../backups/sudoers
cp /etc/sudoers.d ../backups/sudoers.d
chmod 777 ../backups/sudoers
chmod 777 ../backups/sudoers.d
print "sudoers & sudoers.d backed up."

# Remove LD_PRELOAD keeps from sudoers and fragments
#look at postscripttasks to figure out what to add here
# Remove any instance of NOPASSWD or !authenticate or env_keep

# Validate live file and restore if needed
if visudo -c; then
  print "Sudoers syntax validated successfully."
else
  print "Syntax error detected, restoring backups. CONFIGURE MANUALLY!!!!"
  cp -a ../backups/sudoers /etc/sudoers
  cp -a ../backups/sudoers.d /etc/sudoers.d
fi

#Disable system core dumps
cp ./importfiles/limits.conf /etc/security/limits.conf
print "Core dumps disabled with limits.conf."

#Remove prohibited mp3 files
print "Can users have media files?"
read mediastatus
if [[ $mediastatus == "no" || $mediastatus == "n" ]];
then
	read -p "Enter your username: " USERNAME
	MYHOME="/home/$USERNAME"
	#audio files
	find /home -path "$MYHOME" -prune -o -type f \( -name "*.midi" -o -name "*.mid" -o -name "*.mp3" -o -name "*.mp2" -o -name "*.mpa" -o -name "*.abs" -o -name "*.mpega" -o -name "*.au" -o -name "*.snd" -o -name "*.aiff" -o -name "*.aif" -o -name "*.sid" -o -name "*.flac" \) -delete 2>> $LOG
	print "Audio files removed."
	#video files
	find /home -path "$MYHOME" -prune -o -type f \( -name "*.mpeg" -o -name "*.mpe" -o -name "*.dl" -o -name "*.movie" -o -name "*.movi" -o -name "*.mv" -o -name "*.iff" -o -name "*.anim5" -o -name "*.anim3" -o -name "*.anim7" -o -name "*.avi" -o -name "*.vfw" -o -name "*.avx" -o -name "*.fli" -o -name "*.flc" -o -name "*.mov" -o -name "*.qt" -o -name "*.spl" -o -name "*.swf" -o -name "*.dcr" -o -name "*.dxr" -o -name "*.rpm" -o -name "*.rm" -o -name "*.smi" -o -name "*.ra" -o -name "*.ram" -o -name "*.rv" -o -name "*.wmv" -o -name "*.asf" -o -name "*.asx" -o -name "*.wma" -o -name "*.wax" -o -name "*.wmv" -o -name "*.wmx" -o -name "*.3gp" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name "*.swf" -o -name "*.flv" -o -name "*.m4v" \) -delete 2>> $LOG
	print "Video files removed."
	#image files
	find /home -path "$MYHOME" -prune -o -type f \( -name "*.tiff" -o -name "*.tif" -o -name "*.rs" -o -name "*.im1" -o -name "*.gif" -o -name "*.jpeg" -o -name "*.jpg" -o -name "*.jpe" -o -name "*.png" -o -name "*.rgb" -o -name "*.xwd" -o -name "*.xpm" -o -name "*.ppm" -o -name "*.pbm" -o -name "*.pgm" -o -name "*.pcx" -o -name "*.ico" -o -name "*.svg" -o -name "*.svgz" \) -delete 2>> $LOG
	print "Image files removed."
	print "All media files have been removed within /home directories."
else
	print "Media files have not been configured."
fi
