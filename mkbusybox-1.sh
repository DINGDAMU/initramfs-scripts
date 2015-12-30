BUSYBOX=`pwd`/busybox-1.3.2.tar.gz      # The path to busybox-1.3.2.tar.gz, for example...
ORIG=`pwd`
mkdir -p $1

cd $1
if [ -z $BUSYBOX ];
then
echo "Wrong directory of BUSYBOX"
exit
else
tar xvzf $BUSYBOX
fi
cd busybox-1.3.2
cp $ORIG/busybox_config .config
make ARCH=arm CROSS_COMPILE="$3"- oldconfig
make ARCH=arm CROSS_COMPILE="$3"-
ln -s $2 ./_install
make ARCH=arm CROSS_COMPILE="$3"- install

