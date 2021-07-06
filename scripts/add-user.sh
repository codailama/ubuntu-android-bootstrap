#!/bin/sh
# generate user files in the bootstrap

useradd -m -d /home/$1 -s /bin/bash -u $2 $1
echo "$1    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers