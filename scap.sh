#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#Installing OpenSCAP-Workbench
apt-get install build-essential pkg-config cmake g++ libopenscap-dev qtbase5-dev qt5-qmake qtbase5-dev-tools libqt5widgets5 libqt5xmlpatterns5-dev asciidoc -y | sudo tee -a $LOG
git clone https://github.com/OpenSCAP/scap-workbench.git
cd scap-workbench
sudo rm -rf build
mkdir build
cd build
touch ../doc/user_manual.html
cmake ../
make
make install

#check files
cd ../
cd ../
apt-get install python3-jinja2 -y | sudo tee -a $LOG
git clone -b master https://github.com/ComplianceAsCode/content.git
cd content/build/
cmake ../
make -j4


print "scap-workbench should be ready for use. Use the ds file within ~/content/build."
