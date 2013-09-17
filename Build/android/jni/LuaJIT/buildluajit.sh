#/usr/bin/env bash

usage()
{
cat << EOF
usage: $0 -f LuaJIT_RootDir [OPTIONS]

OPTIONS:
    -h  Show this message

    -f  Path to the LuaJIT root directory. It should have the README file
        in this directory.

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

    -a  Architecture. As of ndk-r9 possible options are 
        armeabi|armeabi-v7a|mips|x86
        You can specify this option multiple times
        Default: -a armeabi -a armeabi-v7a -a mips -a x86
EOF
}

TOPDIR=`pwd`
INSTALLDIR=$TOPDIR
LUAJITDIR=
NDK_TOOLCHAIN=4.8
NDKPLAT=android-9
BUILD_ARCHS=""

#should return x86 or x86_64
USER_HOST_ARCH=`uname -m`

NDK=`which ndk-build | sed -rn -e "s/^(.+)ndk\-build/\1/gp"`

while getopts "hf:t:p:n:a:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        f)
            LUAJITDIR=$OPTARG
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
        a)
            BUILD_ARCHS+="$OPTARG "
            ;;
        ?)
            usage
            exit 
            ;;
    esac
done

if [[ -z $BUILD_ARCHS ]]; then
    BUILD_ARCHS="armeabi armeabi-v7a mips x86"
fi

if [[ -z $LUAJITDIR ]]; then
    usage
    exit
fi

echo "Building for $BUILD_ARCHS"


#arm
ARM_NDKVER=$NDK/toolchains/arm-linux-androideabi-$NDK_TOOLCHAIN
ARM_NDKP=$ARM_NDKVER/prebuilt/linux-$USER_HOST_ARCH/bin/arm-linux-androideabi-
ARM_NDKF="--sysroot $NDK/platforms/$NDKPLAT/arch-arm -fPIC"
if [[ $BUILD_ARCHS =~ armeabi\  ]]; then
make -C $LUAJITDIR  HOST_CC="gcc -m32 " CROSS=$ARM_NDKP \
                    TARGET_FLAGS="$ARM_NDKF -mthumb -mfloat-abi=soft" \
                    TARGET_SYS=Linux PREFIX=$INSTALLDIR/armeabi -j5
make -C $LUAJITDIR install PREFIX=$INSTALLDIR/armeabi
make -C $LUAJITDIR clean
fi

#armv7
ARM_NDKARCH="-march=armv7-a -mfloat-abi=softfp -mfpu=neon -Wl,--fix-cortex-a8"
if [[ $BUILD_ARCHS =~ armeabi\-v7a ]]; then
make -C $LUAJITDIR  HOST_CC="gcc -m32" CROSS=$ARM_NDKP \
                    TARGET_FLAGS="$ARM_NDKF $ARM_NDKARCH" \
                    TARGET_SYS=Linux PREFIX=$INSTALLDIR/armeabi-v7a -j5
make -C $LUAJITDIR PREFIX=$INSTALLDIR/armeabi-v7a install
make -C $LUAJITDIR clean
fi


#mips
MIPS_NDKVER=$NDK/toolchains/mipsel-linux-android-$NDK_TOOLCHAIN
MIPS_NDKP=$MIPS_NDKVER/prebuilt/linux-$USER_HOST_ARCH/bin/mipsel-linux-android-
MIPS_NDKF="--sysroot $NDK/platforms/$NDKPLAT/arch-mips -fPIC"
if [[ $BUILD_ARCHS =~ mips ]]; then
make -C $LUAJITDIR  HOST_CC="gcc -m32" CROSS=$MIPS_NDKP \
                    TARGET_FLAGS="$MIPS_NDKF" \
                    TARGET_SYS=Linux PREFIX=$INSTALLDIR/mips -j5
make -C $LUAJITDIR PREFIX=$INSTALLDIR/mips install
make -C $LUAJITDIR clean
fi
#x86
X86_NDKVER=$NDK/toolchains/x86-$NDK_TOOLCHAIN
X86_NDKP=$X86_NDKVER/prebuilt/linux-$USER_HOST_ARCH/bin/i686-linux-android-
X86_NDKF="--sysroot $NDK/platforms/$NDKPLAT/arch-x86 -fPIC"
if [[ $BUILD_ARCHS =~ x86 ]]; then
make -C $LUAJITDIR  HOST_CC="gcc -m32" CROSS=$X86_NDKP \
                    TARGET_FLAGS="$X86_NDKF" \
                    TARGET_SYS=Linux PREFIX=$INSTALLDIR/x86 -j5
make -C $LUAJITDIR PREFIX=$INSTALLDIR/x86 install
make -C $LUAJITDIR clean
fi

