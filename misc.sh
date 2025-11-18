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
DEBIAN_FRONTEND=noninteractive sudo apt-get install unattended-upgrades "-y" "-qq" >> $LOG
	# Enable automatic upgrades and set update frequency (adjust per policy)
echo 'APT::Periodic::Update-Package-Lists "1";' | sudo tee /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' | sudo tee -a /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";' | sudo tee -a /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";' | sudo tee -a /etc/apt/apt.conf.d/10periodic
#change smth in /etc/apt/apt.conf.d/ (50unattended-upgrades?)
else #Mint 21
fi

#sysctl.conf
cp ./importfiles/sysctl.conf /etc/sysctl.conf
sysctl -w net.ipv4.route.flush=1

sysctl --system
sysctl -p
sudo systemctl daemon-reload
print "sysctl.conf configured."

#/etc/shells config
sed -i '/nologin/c\\' /etc/shells
print "instances of nologin removed from /etc/shells."

#Disable Ctrl+Alt+Delete Reboot
systemctl disable ctrl-alt-del.target
systemctl mask ctrl-alt-del.target
systemctl daemon-reload
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
cp /etc/sudoers ./backups/sudoers
cp -a /etc/sudoers.d ./backups/sudoers.d
chmod 777 ./backups/sudoers
#chmod 777 ./backups/sudoers.d
print "sudoers & sudoers.d backed up."

# Remove LD_PRELOAD keeps from sudoers and fragments
#look at postscripttasks to figure out what to add here
# Remove any instance of NOPASSWD or !authenticate or env_keep
find /etc/sudoers /etc/sudoers.d -type f -exec sed -i '/NOPASSWD/ s/^/# /g' {} \;
print "instances of NOPASSWD in /etc/sudoers and /etc/sudoers.d removed."


# Validate live file and restore if needed
if visudo -c; then
  print "Sudoers syntax validated successfully."
else
  print "Syntax error detected, restoring backups. CONFIGURE MANUALLY!!!!"
  cp ./backups/sudoers /etc/sudoers
  cp -a ./backups/sudoers.d /etc/sudoers.d
fi

#Remove prohibited mp3 files
print "Can users have media files?"
read mediastatus
if [[ $mediastatus == "no" || $mediastatus == "n" ]];
then
	#audio files
	find /home -type f \( -name "*.midi" -o -name "*.mid" -o -name "*.mp3" -o -name "*.mp2" -o -name "*.mpa" -o -name "*.abs" -o -name "*.mpega" -o -name "*.au" -o -name "*.snd" -o -name "*.aiff" -o -name "*.aif" -o -name "*.sid" -o -name "*.flac" -o -name "*.ogg" \) -delete 2>> $LOG
	print "Audio files removed."
	#video files
	find /home -type f \( -name "*.mpeg" -o -name "*.mpe" -o -name "*.dl" -o -name "*.movie" -o -name "*.movi" -o -name "*.mv" -o -name "*.iff" -o -name "*.anim5" -o -name "*.anim3" -o -name "*.anim7" -o -name "*.avi" -o -name "*.vfw" -o -name "*.avx" -o -name "*.fli" -o -name "*.flc" -o -name "*.mov" -o -name "*.qt" -o -name "*.spl" -o -name "*.swf" -o -name "*.dcr" -o -name "*.dxr" -o -name "*.rpm" -o -name "*.rm" -o -name "*.smi" -o -name "*.ra" -o -name "*.ram" -o -name "*.rv" -o -name "*.wmv" -o -name "*.asf" -o -name "*.asx" -o -name "*.wma" -o -name "*.wax" -o -name "*.wmv" -o -name "*.wmx" -o -name "*.3gp" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name "*.swf" -o -name "*.flv" -o -name "*.m4v" \) -delete 2>> $LOG
	print "Video files removed."
	#image files
	find /home -type f \( -name "*.tiff" -o -name "*.tif" -o -name "*.rs" -o -name "*.im1" -o -name "*.gif" -o -name "*.jpeg" -o -name "*.jpg" -o -name "*.jpe" -o -name "*.png" -o -name "*.rgb" -o -name "*.xwd" -o -name "*.xpm" -o -name "*.ppm" -o -name "*.pbm" -o -name "*.pgm" -o -name "*.pcx" -o -name "*.ico" -o -name "*.svg" -o -name "*.svgz" \) -delete 2>> $LOG
	print "Image files removed."
	print "All media files have been removed within /home directories."
else
	print "Media files have not been configured."
fi
