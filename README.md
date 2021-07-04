# android-linux-bootstrap

Debian bootstrap archive for Android API 16+. Used in codailama/octo4a.

## Setup

To setup the bootstrap, extract it anywhere  and run:
`./install-bootstrap.sh`

This will extract and setup the bundled debian linux rootfs. You can later access it by using the `run-bootstrap.sh` script.

This script uses [green-green-avk's proot build script](https://github.com/green-green-avk/build-proot-android).