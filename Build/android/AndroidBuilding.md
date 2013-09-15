This is a hacky solution for now.

How it is configured by default:
Directory structure looks like


    /lua-5.1.5
    /freetype
    /rocket
        /Source
        /Include
        /Build
        :
        :



If that is not how you have it laid out, change the following variables:
(all relative to this file)

jni/lua/Android.mk:

    MY_LUA_SRC_PATH

easy enough, right?


== Build Freetype ==
You should only need to do this once.
Navigate to jni/freetype, and do

    ./buildfreetype.sh -f ../../../../../freetype

Which will build it with default values for gcc4.8. See 

    ./buildfreetype.sh -h

to see the defaults and usage.


== Build Rocket ==
By default, this links with freetype and lua statically. To change that,
all you need to do is change LOCAL_STATIC_LIBRARIES and LOCAL_SHARED_LIBRARIES
to read freetype_static|freetype_shared and/or lua_static|lua_shared.

If you are fine with shared libraries, then just type ndk-build (I suggest
multiple jobs, something like ndk-build -j5).



Make sure to read the 4 options in Application.mk.
