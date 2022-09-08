#!/bin/bash

 

set -e

set -x

 

echo `date` > runtime.txt

 

# (2020.2) tools

#source 2020.2.sh

 

export buildroot=`pwd`

# NOTE link to your appropriate files here:
<<<<<<< HEAD
prebuilt=/home/zhizhenzhong/ZCU216PYNQFILES/focal.aarch64.2.7.0_2021_11_17.tar.gz
=======
prebuilt=/home/zhizhenzhong/focal.aarch64.2.7.0_2021_11_17.tar.gz
>>>>>>> ba0af1f4bce4d9ee7938a73a8e415d7ed484ae4e
bsp=/home/zhizhenzhong/xilinx-zcu216-v2020.2-final.bsp
 

if [ ! -e "$prebuilt" ]; then

    echo "$prebuilt DNE"

    exit

fi

 

if [ ! -d "ZCU216-PYNQ" ]; then

    git clone --recursive https://github.com/zhizhenzhong/ZCU216-PYNQ

fi

 

pushd ZCU216-PYNQ/ZCU216

ln -s $bsp

popd

 

# git build.sh so that other boards are not rebuilt

pushd ZCU216-PYNQ/PYNQ

echo "" > build.sh

git commit -a -m "clean out build.sh"

popd

 
# move tics files to proper directory
cp -a ZCU216-PYNQ/tics/. ZCU216-PYNQ/PYNQ/sdbuild/packages/xrfclk/package/xrfclk/

pushd ZCU216-PYNQ/PYNQ/sdbuild

bash /home/zhizhenzhong/ZCU216-PYNQ/ZCU216-PYNQ/PYNQ/sdbuild/scripts/setup_host.sh

export PATH=/opt/qemu/bin:/opt/crosstool-ng/bin:$PATH

source /tools/XilinxSw/Vitis/2020.2/settings64.sh
source /tools/Xilinx/PetaLinux/2020.2/bin/settings.sh
petalinux-util --webtalk off

make BOARDDIR=$buildroot/ZCU216-PYNQ PREBUILT=$prebuilt

 

BOARD=ZCU216

VERSION=2.7.0

boardname=$(echo ${BOARD} | tr '[:upper:]' '[:lower:]' | tr - _)

timestamp=$(date +'%Y_%m_%d')

imagefile=${boardname}_${timestamp}.img

zipfile=${boardname}_${timestamp}.zip

mv output/${BOARD}-${VERSION}.img $imagefile

zip -j $zipfile $imagefile

 

popd

 

 

 

echo `date` >> runtime.txt

 

cat runtime.txt

 
