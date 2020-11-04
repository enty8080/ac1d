include ~/theos/makefiles/common.mk
export TARGET_CODESIGN_FLAGS = "-Ssign.plist"
TOOL_NAME = ac1d

ac1d_FILES = ac1d.m main.mm
ac1d_FRAMEWORS = Foundation

include ~/theos/makefiles/tool.mk

export ARCHS = armv7 arm64

CFLAGS = -Wall -g
