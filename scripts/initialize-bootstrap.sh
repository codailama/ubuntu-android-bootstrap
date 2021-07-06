#!/bin/sh
#Install basic packages
echo "DEBIAN_FRONTEND=noninteractive" >> /etc/environment
echo "DEBCONF_NONINTERACTIVE_SEEN=true" >> /etc/environment

echo "export DEBIAN_FRONTEND=noninteractive"  >> /etc/profile
echo "export DEBCONF_NONINTERACTIVE_SEEN=true"  >> /etc/profile
source /etc/profile

apt update
apt-get install --no-install-recommends -y vim \
  ffmpeg \
  curl \
  git \
  daemonize \
  sudo \
  nginx \
  bash \
  openssh-server \
  gcc-aarch64-linux-gnu \
  build-essential \
  python3-dev

# Configure sshd
echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config
ssh-keygen -A
mkdir -p /var/run/sshd
chmod 700 /var/run/sshd

# Generate ioctl.so
gcc -fPIC -c -o ioctlHook.o /root/ioctlHook.c
gcc -shared -o ioctlHook.so ioctlHook.o -ldl
cp ioctlHook.so /home/octoprint/ioctlHook.so
