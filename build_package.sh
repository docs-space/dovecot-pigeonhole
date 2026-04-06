#!/bin/sh
VERSION=$1
DIR_FILES=$2
DOVECOT_DIRECTORY=$3

sudo apt update
sudo apt-get install -y zip unzip

#sudo cp -r $DOVECOT_DIRECTORY/Pack/src/* $DIR_FILES/Pack/src/

sudo sed -i "s/Version:.*/Version: ${VERSION}/" $DOVECOT_DIRECTORY/Pack/src/DEBIAN/control
sudo sed -i "s/Source:.*/Source: r7mdaserver (${VERSION})/" $DOVECOT_DIRECTORY/Pack/src/DEBIAN/control
sudo sed -i "s/Package:.*/Package: r7mdaserver/" $DOVECOT_DIRECTORY/Pack/src/DEBIAN/control
sudo sed -i "s/Installed-Size:.*/Installed-Size: $(du -sk $DOVECOT_DIRECTORY/Pack/src | cut -f1)/" $DOVECOT_DIRECTORY/Pack/src/DEBIAN/control
( cd "$DOVECOT_DIRECTORY/Pack/src" && rm -f DEBIAN/md5sums && find . -type f ! -path '*/DEBIAN/*' -exec md5sum {} > DEBIAN/md5sums \; )

sudo dpkg-deb -b $DOVECOT_DIRECTORY/Pack/src $DIR_FILES/Packages/r7mdaserver_${VERSION}.deb

#cd $DIR_FILES/Pack/src/ && sudo zip -r $DIR_FILES/Packages/r7mdaserver_${VERSION}.zip *
#sudo md5sum $DIR_FILES/Packages/r7mdaserver_${VERSION}.zip >> $DIR_FILES/Packages/md5.txt