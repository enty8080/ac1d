include ~/theos/makefiles/common.mk
export SYSROOT = /Users/teleprosheo/Desktop/iPhoneOS9.3.sdk
export TARGET_CODESIGN_FLAGS = "-Ssign.plist"
TOOL_NAME = ac1d

ac1d_FILES = main.mm ac1d.m
ac1d_FRAMEWORS = Foundation UIKit AudioToolbox

include ~/theos/makefiles/tool.mk

export ARCHS = armv7 arm64

CFLAGS = -Wall -g
