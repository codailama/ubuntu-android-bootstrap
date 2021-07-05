#!/bin/bash
echo "Creating bootstrap for all archs"
SCRIPTS_PATH=$PWD
echo "Building proot..."
cd ../external/proot/

./build.sh

echo "Building minitar..."
cd ../minitar
./build.sh

cd $SCRIPTS_PATH
mkdir -p build
cd build
rm -rf *
cp ../ioctlHook.c .
#../build-ioctl-hook.sh

cp -r ../../external/proot/build/* .

build_bootstrap () {
	echo "Packing bootstrap for arch $1"
	
	case $1 in
	arm64)
		PROOT_ARCH="aarch64"
		ANDROID_ARCH="arm64-v8a"
		MUSL_ARCH="aarch64-linux-musl"
		GO_ARCH="arm64"
		;;
	armhf)
		PROOT_ARCH="armv7a"
		ANDROID_ARCH="armeabi-v7a"
		MUSL_ARCH="arm-linux-musleabihf"
		GO_ARCH="arm"
		;;
	amd64)
		PROOT_ARCH="x86_64"
		ANDROID_ARCH="x86_64"
		MUSL_ARCH="x86_64-linux-musl"
		GO_ARCH="amd64"
		;;
	i386)
		PROOT_ARCH="i686"
		ANDROID_ARCH="x86"
		MUSL_ARCH="i686-linux-musl"
		GO_ARCH="386"
		;;
	*)
		echo "Invalid arch"
		;;
	esac
	cd root-$PROOT_ARCH
	cp ../../../external/minitar/build/libs/$ANDROID_ARCH/minitar root/bin/minitar

	# separate binaries for platforms < android 5 not supporting 64bit
	if [[ "$1" == "armhf" || "$1" == "i386" ]]; then
		cp -r ../root-${PROOT_ARCH}-pre5/root root-pre5
		cp root/bin/minitar root-pre5/bin/minitar
	fi

  rm -rf rootfs.tar.gz
  curl -o rootfs.tar.gz -L "http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.2-base-$1.tar.gz"

  curl -o gotty.tar.gz -L "https://github.com/sorenisanerd/gotty/releases/download/v1.3.0/gotty_v1.3.0_linux_$GO_ARCH.tar.gz"

	cp ../../run-bootstrap.sh .
	cp ../../install-bootstrap.sh .
	cp ../../add-user.sh .
	cp ../../ioctlHook.c .
	zip -r bootstrap-$PROOT_ARCH.zip root ioctlHook.c root-pre5 rootfs.tar.gz run-bootstrap.sh install-bootstrap.sh add-user.sh gotty.tar.gz
	mv bootstrap-$PROOT_ARCH.zip ../
	echo "Packed bootstrap $1"
	cd ..
}

build_bootstrap arm64
build_bootstrap armhf
build_bootstrap amd64
#build_bootstrap i386
