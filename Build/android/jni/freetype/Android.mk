LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := freetype_static
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/lib/libfreetype.a
#have to have them both
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/include $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/include/freetype2
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := freetype_shared
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/lib/libfreetype.so
#have to have them both
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/include $(LOCAL_PATH)/$(TARGET_ARCH_ABI)/include/freetype2
include $(PREBUILT_SHARED_LIBRARY)
