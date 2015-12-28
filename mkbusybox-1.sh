BUSYBOX=`pwd`/busybox-1.3.2.tar.gz
BUSYBOX_A=/tmp/A
ORIG=`pwd`
GNU_NAME=arm-unknown-linux-gnu
ROOT=/tmp/rootfs
mkdir -p $BUSYBOX_A

cd $BUSYBOX_A
tar xvzf $BUSYBOX
cd busybox-1.3.2
cp $ORIG/busybox_config .config
make ARCH=arm CROSS_COMPILE="$GNU_NAME"- oldconfig
make ARCH=arm CROSS_COMPILE="$GNU_NAME"-
ln -s $ROOT ./_install
make ARCH=arm CROSS_COMPILE="$GNU_NAME"- install
