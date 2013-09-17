SHELL := /bin/bash
LOCAL_PATH := $(call my-dir)


#This is the default value for LOCAL_SHARED|STATIC_LIBRARIES
#The build scripts include options for both static and dynamic
#libs for freetype,lua, and luajit. Lua and LuaJIT are mutually
#exclusive (you should have only one). 
#
#Valid options for these are 
#freetype_static|shared
#lua_static|shared
#luajit_static|shared
#
#Include directories are exported by those module's Android.mk, so
#no need to worry about changing those
MY_SHARED_LIBRARIES := 
MY_STATIC_LIBRARIES := freetype_static lua_static

include $(CLEAR_VARS)
MY_ROCKET_FILELIST := $(LOCAL_PATH)/../../../cmake/FileList.cmake
#Must start out with the ../, since LOCAL_SRC_FILES automatically
#prepends LOCAL_PATH
MY_ROCKET_ROOTDIR := ../../../../
MY_ROCKET_INCLUDE := $(LOCAL_PATH)/$(MY_ROCKET_ROOTDIR)Include

LOCAL_MODULE := RocketCore
LOCAL_SRC_FILES := $(shell ($(LOCAL_PATH)/getrocketsources.sh Core_SRC_FILES $(MY_ROCKET_FILELIST) $(MY_ROCKET_ROOTDIR)))
LOCAL_C_INCLUDES := $(MY_ROCKET_INCLUDE)
LOCAL_STATIC_LIBRARIES := $(MY_STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES := $(MY_SHARED_LIBRARIES)
LOCAL_CPP_FEATURES := rtti
include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)
LOCAL_MODULE := RocketControls
LOCAL_SRC_FILES := $(shell ($(LOCAL_PATH)/getrocketsources.sh Controls_SRC_FILES $(MY_ROCKET_FILELIST) $(MY_ROCKET_ROOTDIR)))
LOCAL_C_INCLUDES := $(MY_ROCKET_INCLUDE)
LOCAL_STATIC_LIBRARIES := $(MY_STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES := $(MY_SHARED_LIBRARIES) RocketCore
LOCAL_CPP_FEATURES := rtti
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := RocketDebugger
LOCAL_SRC_FILES := $(shell ($(LOCAL_PATH)/getrocketsources.sh Debugger_SRC_FILES $(MY_ROCKET_FILELIST) $(MY_ROCKET_ROOTDIR)))
LOCAL_C_INCLUDES := $(MY_ROCKET_INCLUDE)
LOCAL_STATIC_LIBRARIES := $(MY_STATIC_LIBRARIES) 
LOCAL_SHARED_LIBRARIES := $(MY_SHARED_LIBRARIES) RocketCore RocketControls
LOCAL_CPP_FEATURES := rtti
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := RocketCoreLua
LOCAL_SRC_FILES := $(shell ($(LOCAL_PATH)/getrocketsources.sh Luacore_SRC_FILES $(MY_ROCKET_FILELIST) $(MY_ROCKET_ROOTDIR)))
LOCAL_C_INCLUDES := $(MY_ROCKET_INCLUDE)
LOCAL_STATIC_LIBRARIES := $(MY_STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES := $(MY_SHARED_LIBRARIES) RocketCore
LOCAL_CPP_FEATURES := rtti
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := RocketControlsLua
LOCAL_SRC_FILES := $(shell ($(LOCAL_PATH)/getrocketsources.sh Luacontrols_SRC_FILES $(MY_ROCKET_FILELIST) $(MY_ROCKET_ROOTDIR)))
LOCAL_C_INCLUDES := $(MY_ROCKET_INCLUDE)
LOCAL_STATIC_LIBRARIES := $(MY_STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES := $(MY_SHARED_LIBRARIES) RocketCore RocketControls RocketCoreLua
LOCAL_CPP_FEATURES := rtti
include $(BUILD_SHARED_LIBRARY)

