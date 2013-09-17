This is a hacky solution for now.

How it is configured by default:
Directory structure looks like


    /lua-5.1.5
    /LuaJIT
    /freetype
    /rocket
        /Source
        /Include
        /Build
            /android
                AndroidBuilding.md (this file)
        :
        :



If that is not how you have it laid out, change the following variables:

jni/lua/Android.mk:

    MY_LUA_SRC_PATH


easy enough, right?


## Build Freetype ##

You should only need to do this once.
Navigate to jni/freetype, and do

    ./buildfreetype.sh -f ../../../../../freetype

Which will build it with default values for gcc4.8. See 

    ./buildfreetype.sh -h

to see the defaults and usage.

## Build LuaJIT _(Optional)_ ##

Download from http://luajit.org/

Read how to build freetype and do the same, except navigate to
jni/LuaJIT and do 
    
    ./buildluajit.sh

This requires using gcc, and if on an x86_64 system, requires 
a 32 bit cross compiler. You can get it from gcc-4.8-multilib and
libc6-dev-i386 packages, or something similar.



## Build Rocket ##

By default, this links with freetype and lua statically. To change that,
all you need to do is change MY_STATIC_LIBRARIES and MY_SHARED_LIBRARIES
to read freetype_static|freetype_shared and/or (lua_static|lua_shared 
or luajit_static|luajit_shared).

If you are fine with Rocket as shared libraries, then just type ndk-build 
(I suggest multiple jobs, something like ndk-build -j5). And if something
goes wrong, always try the clean build ndk-build -B.


Make sure to read the 4 options in Application.mk.


## Current issues ##

Builds lua and luajit both undconditionally. To remedy this, either
rename or delete the Android.mk file for the project which should
not be built. Alternatively, you could have the source from both,
and wait the extra 4 seconds it takes for lua to build, and have
LuaJIT already built.
