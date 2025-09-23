#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#configures updates to daily
echo 'APT::Periodic::Update-Package-Lists "1";' | sudo tee /etc/apt/apt.conf.d/999custom > /dev/nulll
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' | sudo tee -a /etc/apt/apt.conf.d/999custom > /dev/null
echo 'APT::Periodic::AutocleanInterval "7";' | sudo tee -a /etc/apt/apt.conf.d/999custom > /dev/null
echo 'APT::Periodic::Unattended-Upgrade "1";' |  sudo tee -a /etc/apt/apt.conf.d/999custom > /dev/null
find /etc/apt -type f -name '*.list' -exec sed -i 's/^#\(deb.*-backports.*\)/\1/; s/^#\(deb.*-updates.*\)/\1/; s/^#\(deb.*-proposed.*\)/\1/; s/^#\(deb.*-security.*\)/\1/' {} +
print "Updates set to daily (expand on what I am doing)."

#sysctl.conf
cp importfiles/sysctl.conf /etc/sysctl.conf
sysctl -w net.ipv4.route.flush=1
print "sysctl.conf configured."

#remove prohibited mp3 files
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
