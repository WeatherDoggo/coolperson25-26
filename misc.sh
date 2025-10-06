#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#Automatic Updates
if $OS == ubuntu; then
	sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
	print "For Ubuntu 22, automatic updates should be reflected in the GUI."
else #Mint 21
	print "DO THE AUTOMATIC UPDATES MANUALLY!!!"
fi
print "Automatic updates configured."

#sysctl.conf
cp ./importfiles/sysctl.conf /etc/sysctl.conf
sysctl -w net.ipv4.route.flush=1
sysctl --system
print "sysctl.conf configured."

#/etc/shells config
sed -i '/nologin/c\\' /etc/shells
print "instances of noglogin removed from /etc/shells."

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

# Remove lines preserving LD_PRELOAD
sed -i '/env_keep += *"LD_PRELOAD"/d' /etc/sudoers
for file in /etc/sudoers.d/*; do
    sed -i '/env_keep += *"LD_PRELOAD"/d' "$file"
done

# Remove all NOPASSWD and !authenticate from /etc/sudoers
sed -i '/NOPASSWD/d' /etc/sudoers
sed -i '/!authenticate/d' /etc/sudoers

# Ensure Defaults include use_pty, env_reset, timestamp_timeout=15
if grep -q "^Defaults" /etc/sudoers; then
    # Update existing Defaults lines to include required settings
    sed -i '/^Defaults/ {
        s/use_pty//g
        s/env_reset//g
        s/timestamp_timeout=[0-9]*//g
        s/\s\+/, /g
        s/,\+,/,/g
    }' /etc/sudoers

    # Append missing Defaults lines if they don't exist individually
    grep -q 'Defaults use_pty' /etc/sudoers || echo 'Defaults use_pty' >> /etc/sudoers
    grep -q 'Defaults env_reset' /etc/sudoers || echo 'Defaults env_reset' >> /etc/sudoers
    grep -q 'Defaults timestamp_timeout=15' /etc/sudoers || echo 'Defaults timestamp_timeout=15' >> /etc/sudoers
else
    # Add Defaults if none present
    echo 'Defaults use_pty' >> /etc/sudoers
    echo 'Defaults env_reset' >> /etc/sudoers
    echo 'Defaults timestamp_timeout=15' >> /etc/sudoers
fi

# Validate sudoers syntax
if visudo -c; then
    echo "Sudoers syntax validated successfully."
else
    echo "Syntax error detected, restoring backups. CONFIGURE MANUALLY!!!!"
    cp ../backups/sudoers /etc/sudoers
    cp ../backups/sudoers.d /etc/sudoers.d
fi


#Remove prohibited mp3 files
print "Can users have media files?"
read mediastatus
if [[ $mediastatus == "no" || $mediastatus == "n" ]];
then
	#audio files
	find /home -type f \( -name "*.midi" -o -name "*.mid" -o -name "*.mp3" -o -name "*.mp2" -o -name "*.mpa" -o -name "*.abs" -o -name "*.mpega" -o -name "*.au" -o -name "*.snd" -o -name "*.aiff" -o -name "*.aif" -o -name "*.sid" -o -name "*.flac" \) -delete 2>> $LOG
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
