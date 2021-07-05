#!/bin/sh
#Install basic packages
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
apt update
apt-get install --no-install-recommends -y vim \
  ffmpeg \
  curl \
  git \
  daemonize \
  sudo \
  nginx \
  bash

# Configure sshd
echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config
ssh-keygen -A
mkdir -p /var/run/sshd
chmod 700 /var/run/sshd

# Generate ioctl.so
gcc -fPIC -c -o ioctlHook.o /root/ioctlHook.c
gcc -shared -o ioctlHook.so ioctlHook.o -ldl
cp ioctlHook.so /home/octoprint/ioctlHook.so
