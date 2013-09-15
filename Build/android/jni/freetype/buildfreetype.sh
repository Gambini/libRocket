#! /usr/bin/env bash

usage()
{
cat << EOF
usage: $0 -f freetype_root [OPTIONS]

OPTIONS:
    -h  show this message

    -f  path to the freetype root directory. It should
        have the configure script in this directory.
        Default: no default

    -t  NDK toolchain; It can currently be one of
        4.6|4.8|clang3.2|clang3.3
        Default: 4.8

    -p  NDK platform; If you are wanting to compile for mips
        or x86, this must be 8 or higher. As of ndk-r9, 
        possible values are
        android-3|4|5|8|9|14|18 
        which is in the NDK/platforms directory. If using 
        ndk-build, acessable from TARGET_PLATFORM
        Default: android-9

    -n  Path to where ndk-build resides. Use this if you
        do not have ndk-build in your path
        Default: topmost directory from output of 'which ndk-build'
    
    -A  Build for armeabi and armeabi-v7a

    -M  Build for mips

    -X  Build for X86
EOF
}

#ex 4.8
NDK_TOOLCHAIN=4.8
#The abi to target. Should be above 8 to target mips and x86
NDKPLAT=android-9
#the list of architectures to build
BUILD_ARCHS=""
#path to the freetype root
PATH_TO_FREETYPE=
#current working directory. Freetype gets installed to $TOPDIR/ARCH
TOPDIR=`pwd`
#should return x86 or x86_64
USER_HOST_ARCH=`uname -m`
#shared ndk vars
NDK=`which ndk-build | sed -rn -e "s/^(.+)\/ndk\-build/\1/gp"`

while getopts "hf:t:p:n:AMX" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        f)
            PATH_TO_FREETYPE=$OPTARG
            ;;
        t)
            NDK_TOOLCHAIN=$OPTARG
            ;;
        p)
            NDKPLAT=$OPTARG
            ;;
        n)
            NDK=$OPTARG
            ;;
        A)
            BUILD_ARCHS+=" armeabi armeabiv7a "
            ;;
        M)
            BUILD_ARCHS+=" mips "
            ;;
        X)
            BUILD_ARCHS+=" x86 "
            ;;
        ?)
            usage
            exit 
            ;;
    esac
done

if [[ -z $BUILD_ARCHS ]]; then
    BUILD_ARCHS="armeabi armeabiv7a mips x86"
fi

if [[ -z $PATH_TO_FREETYPE ]]; then
    usage
    exit
fi

echo $BUILD_ARCHS

OLDPATH=`echo $PATH`
#arm
ARM_NDKVER=$NDK/toolchains/arm-linux-androideabi-$NDK_TOOLCHAIN
ARM_NDKSYSROOT=$NDK/platforms/$NDKPLAT/arch-arm
ARM_NDKHOST=$ARM_NDKVER/prebuilt/linux-$USER_HOST_ARCH/bin
ARM_FLAGS="--sysroot $ARM_NDKSYSROOT -mthumb"
PATH=$ARM_NDKHOST:$PATH
if [[ $BUILD_ARCHS =~ armeabi\  ]]; then
$PATH_TO_FREETYPE/configure \
    --with-sysroot=$ARM_NDKSYSROOT/usr/lib \
    --without-zlib \
    --build=$USER_HOST_ARCH-unknown-linux-gnu \
    --host=arm-linux-androideabi \
    --prefix=$TOPDIR/armeabi \
    --exec-prefix=$TOPDIR/armeabi \
    CFLAGS="$ARM_FLAGS" \
    LDFLAGS="$ARM_FLAGS"
make -j5
make install
make clean
fi
PATH=$OLDPATH

#armeabi-v7a
ARMV7_FLAGS="--sysroot $ARM_NDKSYSROOT -march=armv7-a -mfloat-abi=softfp -mfpu=neon -Wl,--fix-cortex-a8"
PATH=$ARM_NDKHOST:$OLDPATH
if [[ $BUILD_ARCHS =~ armeabiv7a ]]; then
$PATH_TO_FREETYPE/configure \
    --with-sysroot=$ARM_NDKSYSROOT/usr/lib \
    --without-zlib \
    --build=$USER_HOST_ARCH-unknown-linux-gnu \
    --host=arm-linux-androideabi \
    --prefix=$TOPDIR/armeabi-v7a \
    --exec-prefix=$TOPDIR/armeabi-v7a \
    CFLAGS="$ARMV7_FLAGS" \
    LDFLAGS="$ARMV7_FLAGS"
make -j5
make install
make clean
fi
PATH=$OLDPATH


#mips
MIPS_NDKVER=$NDK/toolchains/mipsel-linux-android-$NDK_TOOLCHAIN
MIPS_NDKSYSROOT=$NDK/platforms/$NDKPLAT/arch-mips
MIPS_NDKHOST=$MIPS_NDKVER/prebuilt/linux-$USER_HOST_ARCH/bin
MIPS_FLAGS="--sysroot $MIPS_NDKSYSROOT"
PATH=$MIPS_NDKHOST:$OLDPATH
if [[ $BUILD_ARCHS =~ mips ]]; then
$PATH_TO_FREETYPE/configure \
    --with-sysroot=$MIPS_NDKSYSROOT/usr/lib \
    --without-zlib \
    --build=$USER_HOST_ARCH-unknown-linux-gnu \
    --host=mipsel-linux-android \
    --prefix=$TOPDIR/mips \
    --exec-prefix=$TOPDIR/mips \
    CFLAGS="$MIPS_FLAGS" \
    LDFLAGS="$MIPS_FLAGS"
make -j5 
make install 
make clean
fi
PATH=$OLDPATH


#x86
X86_NDKVER=$NDK/toolchains/x86-$NDK_TOOLCHAIN
X86_NDKSYSROOT=$NDK/platforms/$NDKPLAT/arch-x86
X86_NDKHOST=$X86_NDKVER/prebuilt/linux-$USER_HOST_ARCH/bin
X86_FLAGS="--sysroot $X86_NDKSYSROOT"
PATH=$X86_NDKHOST:$OLDPATH
if [[ $BUILD_ARCHS =~ x86 ]]; then
$PATH_TO_FREETYPE/configure \
    --with-sysroot=$X86_NDKSYSROOT/usr/lib \
    --without-zlib \
    --build=$USER_HOST_ARCH-unknown-linux-gnu \
    --host=i686-linux-android \
    --prefix=$TOPDIR/x86 \
    --exec-prefix=$TOPDIR/x86 \
    CFLAGS="$X86_FLAGS" \
    LDFLAGS="$X86_FLAGS"
make -j5 
make install 
make clean
fi
PATH=$OLDPATH

#cleanup the silly amount of autotools files
find $TOPDIR -maxdepth 2 -type f -not -name "buildfreetype.sh" -not -name "Android.mk" | xargs rm
rm -r $TOPDIR/.libs
rm -r $TOPDIR/reference
