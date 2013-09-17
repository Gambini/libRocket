LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := luajit_static
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/lib/libluajit-5.1.a
LOCAL_MODULE_FILENAME := liblua5.1
#have to have them both
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/include/luajit-2.0 
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := luajit_shared
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/lib/libluajit-5.1.so
LOCAL_MODULE_FILENAME := liblua5.1
#have to have them both
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/include/luajit-2.0
include $(PREBUILT_SHARED_LIBRARY)
