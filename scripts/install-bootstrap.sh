#!/system/bin/sh

# unpack debian bootstrap
mkdir bootstrap
cd bootstrap
cat ../rootfs.tar.gz | ../root/bin/minitar
cd ..

# Copy files
cp add-user.sh bootstrap/root
cp ioctlHook.c bootstrap/root
cp initialize-bootstrap.sh bootstrap/root

# Install systemctl improvised
cp systemctl.py bootstrap/usr/bin/systemctl
cp systemctl.py bootstrap/bin/systemctl
cp systemctl.py bootstrap/usr/local/bin/systemctl

echo "export DEBIAN_FRONTEND=noninteractive"  >> bootstrap/etc/profile
echo "export DEBCONF_NONINTERACTIVE_SEEN=true"  >> bootstrap/etc/profile

touch bootstrap/root/.hushlogin
# include resolv.conf
echo "nameserver 8.8.8.8  \
nameserver 8.8.4.4" > bootstrap/etc/resolv.conf

echo "127.0.0.1 localhost localhost" > bootstrap/etc/hosts

mkdir -p proc_faker/proc/fakethings
cp static/proc/* proc_faker/proc/fakethings

echo "bootstrap ready, run with run-bootstrap.sh"
