#!/bin/sh

BUSYBOX=/tmp/A
ROOT=/tmp/rootfs
GNU_NAME=arm-unknown-linux-gnu
CROSS=/tmp/Cross/gcc-4.1.0-glibc-2.3.2
TARGET_LIBS=$CROSS/$GNU_NAME/$GNU_NAME/lib
DEST=/tmp/newfs.img

while getopts :r:b:c:t:d: opt
do 
	case $opt in
	r)echo "-ROOT changing the ROOT's directory"
		unset ROOT
		ROOT=$OPTARG;;
	b)echo "-BUSYBOX changing the BUSYBOX's directory"
		unset BUSYBOX
		BUSYBOX=$OPTARG;;
	c)echo "-CROSS changing the CROSS's directory"
		unset CROSS
		CROSS=$OPTARG;;
	t)echo "-TARGET_LIBS changing the TARGET_LIB's directory"
		unset TARGET_LIBS
		TARGET_LIBS=$OPTARG;;
	d)echo "-DEST changing the DEST's directory"
		unset DEST
		DEST=$OPTARG;;
	*)echo "Using the default directories";;
esac
done
if [ -z $ROOT | $BUSYBOX | $CROSS | $TARGET_LIBS | $DEST ];
then
	echo "some directory is missing"
	exit
fi
mkdir -p $ROOT
cp -ar $TARGET_LIBS $ROOT/lib
cp -ar etc $ROOT/etc

./mkbusybox-1.sh $BUSYBOX $ROOT $GNU_NAME
cd $ROOT
ln -s sbin/init $ROOT/init
#cp /tmp/RTTest/*.ko $ROOT
#cp -a /tmp/Xeno/lib/* /tmp/rootfs/lib
cd $ROOT/lib
rm -rf *.a *.o
rm -rf g*
rm -rf ldscripts
rm -rf liba* libB*
rm -rf libd* libg*
rm -rf libmemu* libmudf*
rm -rf libnss_d*
rm -rf libnss_h*
rm -rf libnss_n* libnss_f*
rm -rf libp*
rm -rf libr* libs*
rm -rf libp* libr* libs*
rm -rf libS* libt* libu*
rm -rf libc.so libc.so_orig

while getopts :k:u:o: what
do
        case $what in
        k) echo "-k adding the kernel module" 
        cp -a  $OPTARG $ROOT/lib/;;
        u) echo "-u adding the user program" 
        cp  $OPTARG $ROOT;;
        o) echo "-b adding the boot scripts"
        cp  $OPTARG $ROOT/etc/init.d/rcS;;
        *) echo "wrong adding the file";;
esac
done
arm-unknown-linux-gnu-strip $ROOT/lib/*
cd $ROOT
find . | cpio -o -H newc | gzip > $DEST
#cd /tmp
#qemu-system-arm -kernel Xeno/zImage -initrd newfs.img -nographic -append "console=ttyAMA0" -M integratorcp
