#!/system/bin/sh
# Minimal proot run script

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: <user> <command>"
	exit 1
fi

BASE_DIR="$PWD"

export PROOT_TMP_DIR="$BASE_DIR/tmp"
export PROOT_L2S_DIR="$BASE_DIR/bootstrap/.proot.meta"

mkdir -p "$PROOT_TMP_DIR"
mkdir -p "$PROOT_L2S_DIR"

if [ "$1" = "root" ]; then
	PATH='/sbin:/usr/sbin:/bin:/usr/bin'
	USER='root'
	HOME='/root'
	OP="-0"
else
	OP=""
	USER="$1"
	PATH='/sbin:/usr/sbin:/bin:/usr/bin'
	HOME="/home/$USER"
fi

BIND_PROC_FAKES=" -b proc_faker/proc/fakethings/stat:/proc/stat"
BIND_PROC_FAKES+=" -b proc_faker/proc/fakethings/vmstat:/proc/vmstat"
BIND_PROC_FAKES+=" -b proc_faker/proc/fakethings/version:/proc/version"

unset TMPDIR
unset LD_LIBRARY_PATH
export PATH
export USER
export HOME
shift
proot -r bootstrap $OP -b /dev -b /proc -b /sys -b /system -b /vendor -b /storage $EXTRA_BIND $BIND_PROC_FAKES --link2symlink -p -L -w $HOME "$@"
