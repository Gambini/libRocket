SHELL := /bin/bash
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
##
# Modify this to point where the lua source files are
# relative to this file
##
MY_LUA_SRC_PATH := $(LOCAL_PATH)/../../../../../lua-5.1.5/src
MY_LUA_SRC_FILES := $(shell (find $(MY_LUA_SRC_PATH)/*.c -type f ! -name "lua.c" ! -name "luac.c" ! -name "print.c" | sed -nr -e "s:$(LOCAL_PATH)/::gp"))
MY_LUA_CFLAGS := -ffast-math -O3 -funroll-loops -DANDROID
LOCAL_MODULE := lua_static
LOCAL_SRC_FILES := $(MY_LUA_SRC_FILES)
LOCAL_EXPORT_C_INCLUDES := $(MY_LUA_SRC_PATH)
LOCAL_CFLAGS := $(MY_LUA_CFLAGS)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := lua_shared
#use the same MY_LUA_SRC_PATH|FILES From before
LOCAL_SRC_FILES := $(MY_LUA_SRC_FILES)
LOCAL_EXPORT_C_INCLUDES := $(MY_LUA_SRC_PATH)
LOCAL_CFLAGS := $(MY_LUA_CFLAGS)
include $(BUILD_SHARED_LIBRARY)

