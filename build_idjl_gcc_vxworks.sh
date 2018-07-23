#! /bin/bash
set -e
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
trap 'echo FAILED COMMAND: $previous_command' EXIT

#-------------------------------------------------------------------------------------------
# This script will download packages for, configure, build and install a GCC cross-compiler.
# Customize the variables (INSTALL_PATH, TARGET, etc.) to your liking before running.
# If you get an error and need to resume the script from some point in the middle,
# just delete/comment the preceding lines before running it again.
#
# Based on http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler
#-------------------------------------------------------------------------------------------

SCRIPT=`realpath $0`
export SCRIPTPATH=`dirname $SCRIPT`
export INSTALL_PATH=${SCRIPTPATH}/install
export TARGET=i586-wrs-vxworks
export CONFIGURATION_OPTIONS="--disable-multilib --disable-threads --disable-libssp --disable-libquadmath --disable-libquadmath-support --enable-libstdcxx --disable-libstdcxx-pch --disable-libitm --disable-libcc1 --with-native-system-header-dir=${SCRIPTPATH}/wrs-vxworks-headers/sys-include"
export PARALLEL_MAKE=-j4
BINUTILS_VERSION=binutils-2.30
export GCC_VERSION=gcc-7.3.0
MPFR_VERSION=mpfr-4.0.1
GMP_VERSION=gmp-6.1.2
MPC_VERSION=mpc-1.1.0
ISL_VERSION=isl-0.18
CLOOG_VERSION=cloog-0.18.1
export PATH=$INSTALL_PATH/bin:$PATH


# Download packages
export http_proxy=$HTTP_PROXY https_proxy=$HTTP_PROXY ftp_proxy=$HTTP_PROXY
wget -nc https://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz
wget -nc https://ftp.gnu.org/gnu/gcc/$GCC_VERSION/$GCC_VERSION.tar.gz
wget -nc https://ftp.gnu.org/gnu/mpfr/$MPFR_VERSION.tar.xz
wget -nc https://ftp.gnu.org/gnu/gmp/$GMP_VERSION.tar.xz
wget -nc https://ftp.gnu.org/gnu/mpc/$MPC_VERSION.tar.gz
wget -nc ftp://gcc.gnu.org/pub/gcc/infrastructure/$ISL_VERSION.tar.bz2
wget -nc ftp://gcc.gnu.org/pub/gcc/infrastructure/$CLOOG_VERSION.tar.gz

# Download VxWorks headers 
# See https://aur.archlinux.org/packages/wrs-vxworks-headers/
# See https://github.com/rbmj/wrs-headers-installer 
wget -nc ftp://ftp.ni.com/pub/devzone/tut/updated_vxworks63gccdist.zip

# Extract VxWorks headers 
unzip updated_vxworks63gccdist.zip
mkdir -p wrs-vxworks-headers/{wind_base/target,share/ldscripts}
cp -dpr --no-preserve=ownership gccdist/WindRiver/vxworks-6.3/host wrs-vxworks-headers/wind_base
cp -dpr --no-preserve=ownership gccdist/WindRiver/vxworks-6.3/target/h/. wrs-vxworks-headers/sys-include
cp -dpr --no-preserve=ownership gccdist/WindRiver/vxworks-6.3/target/h/. wrs-vxworks-headers/include_next_workaround/sys-include
cp -dpr --no-preserve=ownership gccdist/WindRiver/vxworks-6.3/target/h/wrn/coreip/. wrs-vxworks-headers/include
cp -dpr --no-preserve=ownership gccdist/WindRiver/vxworks-6.3/target/h/wrn/coreip/. wrs-vxworks-headers/wind_base/target/h
export WIND_BASE=${SCRIPTPATH}/wrs-vxworks-headers/wind_base
export VSB_DIR=""

cp -dpr --no-preserve=ownership  wrs-vxworks-headers/sys-include install/i586-wrs-vxworks

# Extract everything
for f in *.tar*; do tar xfk $f; done

# Make symbolic links
cd $GCC_VERSION
ln -sf `ls -1d ../mpfr-*/` mpfr
ln -sf `ls -1d ../gmp-*/` gmp
ln -sf `ls -1d ../mpc-*/` mpc
ln -sf `ls -1d ../isl-*/` isl
ln -sf `ls -1d ../cloog-*/` cloog
cd ..

# Build Binutils
mkdir -p build-binutils
cd build-binutils
../$BINUTILS_VERSION/configure --prefix=$INSTALL_PATH --target=$TARGET $CONFIGURATION_OPTIONS
make $PARALLEL_MAKE
make install
cd ..

# Build C/C++ Compilers
mkdir -p build-gcc
cd build-gcc
../$GCC_VERSION/configure --prefix=$INSTALL_PATH --target=$TARGET --enable-languages=c,c++ $CONFIGURATION_OPTIONS 
make $PARALLEL_MAKE all-gcc
make install-gcc
cd ..

# Standard C Library Headers and Startup Files
# mkdir -p build-glibc
# cd build-glibc
# ../$GLIBC_VERSION/configure --prefix=$INSTALL_PATH/$TARGET --build=$MACHTYPE --host=$TARGET --target=$TARGET --with-headers=$INSTALL_PATH/$TARGET/include $CONFIGURATION_OPTIONS libc_cv_forced_unwind=yes
# make install-bootstrap-headers=yes install-headers
# make $PARALLEL_MAKE csu/subdir_lib
# install csu/crt1.o csu/crti.o csu/crtn.o $INSTALL_PATH/$TARGET/lib
# $TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $INSTALL_PATH/$TARGET/lib/libc.so
# touch $INSTALL_PATH/$TARGET/include/gnu/stubs.h
# cd ..

# Standard C Library Headers 
# export CPATH=${SCRIPTPATH}/wrs-vxworks-headers/sys-include

# Compiler Support Library
cd build-gcc
make $PARALLEL_MAKE all-target-libgcc
make install-target-libgcc
cd ..

# Standard C++ Library
cd build-gcc
make $PARALLEL_MAKE all-target-libstdc++-v3
make install
cd ..

# the rest of GCC
# cd build-gcc
# make $PARALLEL_MAKE all
# make install
# cd ..

trap - EXIT
echo 'Success!'
