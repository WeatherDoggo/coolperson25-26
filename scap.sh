#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#Installing OpenSCAP-Workbench
apt-get install pkg-config cmake g++ libopenscap-dev qtbase5-dev qt5-qmake libqt5xmlpatterns5-dev xmllint asciidoc -y -qq >> $LOG
git clone https://github.com/OpenSCAP/scap-workbench.git
cd scap-workbench
sudo rm -rf build
mkdir build
cd build
cmake ../
make
make install

#check files
git clone -b master https://github.com/ComplianceAsCode/content.git
cd content/build/
cmake ../
make -j4


print "scap-workbench should be ready for use. Use the ds file within ~/content/build for ubuntu 24."
