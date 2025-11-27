#!/bin/sh
VERSION=$1
DIR_FILES=$2
DOVECOT_DIRECTORY=$3

sudo apt update
sudo apt-get install -y zip unzip

sudo cp -r $DOVECOT_DIRECTORY/Pack/src $DIR_FILES/Pack/src
cd $DIR_FILES/Pack/src/ && sudo zip -r $DIR_FILES/Packages/r7mdaserver_${VERSION}.zip *
sudo md5sum $DIR_FILES/Packages/r7mdaserver_${VERSION}.zip >> $DIR_FILES/Packages/md5.txt