#!/system/bin/sh

# unpack debian bootstrap
mkdir bootstrap
cd bootstrap
cat ../rootfs.tar.gz | ../root/bin/minitar
cd ..

# Copy files
cp ioctlHook.c bootstrap/root
cp initialize-bootstrap.sh bootstrap/root

# Install systemctl improvised
cp systemctl.py bootstrap/usr/bin/systemctl

# include resolv.conf
echo "nameserver 8.8.8.8  \
nameserver 8.8.4.4" > bootstrap/etc/resolv.conf

echo "bootstrap ready, run with run-bootstrap.sh"
