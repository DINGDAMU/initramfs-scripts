#!/bin/sh

ROOT=/tmp/rootfs
GNU_NAME=arm-unknown-linux-gnu
BUSYBOX=/tmp/A
CROSS=/tmp/Cross/gcc-4.1.0-glibc-2.3.2
TARGET_LIBS=$CROSS/$GNU_NAME/$GNU_NAME/lib
DEST=/tmp/newfs.img
LIB=/tmp/rootfs/lib

mkdir -p $ROOT
cp -ar $TARGET_LIBS $ROOT/lib
cp -ar etc $ROOT/etc
./mkbusybox-1.sh
ln -s sbin/init $ROOT/init
#cp /tmp/RTTest/*.ko $ROOT
#cp -a /tmp/Xeno/lib/* /tmp/rootfs/lib
while getopts :k:u:b: opt
do 
	case $opt in
	k) echo "-k adding the kernel module" 
	cp  $OPTARG /tmp/rootfs/;;
	u) echo "-u adding the user program" 
 	cp  $OPTARG /tmp/rootfs/;;
	b) echo "-b adding the boot scripts"
	cp  $OPTARG /tmp/rootfs/etc/init.d/rcS;;
	*) echo "wrong adding the file"
esac
done
cd $LIB
rm -rf *.a *.o 
rm -rf g*
rm -rf ldscripts
rm -rf liba* libB*
rm -rf libd* libg*
rm -rf libmemu* libmudf*
rm -rf libnss_d*
rm -rf libnss_h* 
rm -rf libnss_n*
rm -rf libnss_f*
rm -rf libp*
rm -rf libr* libs*
rm -rf libS* libt* libu* 
rm -rf libc.so libc.so_orig
arm-unknown-linux-gnu-strip $LIB/*
cd $ROOT
find . | cpio -o -H newc | gzip > $DEST
#cd /tmp
#qemu-system-arm -kernel Xeno/zImage -initrd newfs.img -nographic -append "console=ttyAMA0" -M integratorcp
