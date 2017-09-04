LOCAL_PATH := $(call my-dir)
INCLUDE_CPLUSPLUS11_FILES = 0
INCLUDE_7Z_SUPPORT = 1
USE_OLD_MAPPING = 0
EXTERNAL_ZLIB = 0
BUILD_X64_EXE = 0
WANT_NEOGEOCD = 0

ROOT_DIR		:= ..
MAIN_FBA_DIR	:= $(ROOT_DIR)/src

ifeq ($(TARGET_ARCH),arm)
	COMMON_FLAGS += -DANDROID_ARM -DARM -marm
endif

ifeq ($(TARGET_ARCH_ABI), armeabi)
	LOCAL_ARM_MODE := arm
endif

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
	CFLAGS += -munaligned-access
endif

ifeq ($(TARGET_ARCH),x86)
	COMMON_FLAGS += -DANDROID_X86
endif

ifeq ($(TARGET_ARCH),mips)
	COMMON_FLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

SOURCES_C   :=
SOURCES_CXX :=
FBA_DEFINES	:=

include ../makefile.libretro_common

ENDIANNESS_DEFINES	:= -DLSB_FIRST
GLOBAL_DEFINES		:= $(FBA_DEFINES) $(ENDIANNESS_DEFINES)

COMMON_FLAGS		+= -DNDEBUG -DUSE_SPEEDHACKS -D__LIBRETRO_OPTIMIZATIONS__ -D__LIBRETRO__ -DANDROID -DFRONTEND_SUPPORTS_RGB565 -Wno-write-strings -fexceptions -frtti
COMMON_OPTFLAGS		:= -O3 -ffast-math

# Build static C module
include $(CLEAR_VARS)
LOCAL_MODULE						:= libretro-c
LOCAL_SRC_FILES						:= $(SOURCES_C)
LOCAL_C_INCLUDES					:= $(INCLUDE_DIRS)
LOCAL_CFLAGS						:= $(COMMON_OPTFLAGS) $(CFLAGS) $(COMMON_FLAGS) $(GLOBAL_DEFINES)
LOCAL_LDLIBS						:= $(LDFLAGS)
LOCAL_DISABLE_FORMAT_STRING_CHECKS	:= true

include $(BUILD_STATIC_LIBRARY)

# Build shared library including static C module
include $(CLEAR_VARS)
LOCAL_MODULE						:= libretro
LOCAL_STATIC_LIBRARIES				:= libretro-c
LOCAL_SRC_FILES						:= $(SOURCES_CXX)
LOCAL_C_INCLUDES					:= $(INCLUDE_DIRS)
LOCAL_CFLAGS						:= $(COMMON_OPTFLAGS) $(CXXFLAGS) $(COMMON_FLAGS) $(GLOBAL_DEFINES)
LOCAL_LDLIBS						:= $(LDFLAGS)
LOCAL_DISABLE_FORMAT_STRING_CHECKS	:= true

include $(BUILD_SHARED_LIBRARY)
