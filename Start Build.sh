#!/bin/bash
clear
export BUILD_USER=chris
export DEVICE=herolte
export SYSTEM_PATH=~/LineageOS/17.1_LineageOS
export OUTPUT_PATH=$SYSTEM_PATH/out/target/product/$DEVICE
export FILENAME="lineage-17.1-"$(date +"%Y%m%d")"-UNOFFICIAL_microG_ready-$DEVICE.zip"
export SEARCH_FILENAME="lineage-17.1-$TARGET_DATE*-UNOFFICIAL-$DEVICE.zip"
export VERSION="17.1"
export PATH="$HOME/bin:$PATH"
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx6g"
export WITH_SU=false
export USE_CCACHE=1

cd $SYSTEM_PATH

read -p "Sync Android repo? (yes/no)[yes]: " SYNC_REPO
SYNC_REPO="${SYNC_REPO:=yes}"

echo

if [ $SYNC_REPO = 'yes' ]; then
	repo sync -c --force-sync --no-clone-bundle --no-tags

else
	echo "Skipping repo sync. Using currently available sources."
fi;



source build/envsetup.sh
brunch herolte


#make clean && make installclean

#clear "Hole https://gerrit.omnirom.org 23635"
#repopick -P bootable/recovery-twrp -g https://gerrit.omnirom.org 23635

#croot
#brunch $DEVICE


if [ -e $OUTPUT_PATH/$FILENAME  ]; then
	
	md5sum $OUTPUT_PATH/$FILENAME > $OUTPUT_PATH/$FILENAME".md5sum"	
	
	echo "Upload auf OTA-Server"
	publish_rom.sh
	
	echo "FTP-Upload zu AFH"
	cd $OUTPUT_PATH
	#rom2ftp.sh $FILENAME
	
fi

echo 
echo 

cd $SYSTEM_PATH

read -p "Make clean? (yes)" CLEAN
CLEAN="${CLEAN:=yes}"

cd $SYSTEM_PATH
if [ $CLEAN = 'yes' ]; then
	make clean && make installclean
fi
