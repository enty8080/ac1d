include ~/theos/makefiles/common.mk
export TARGET_CODESIGN_FLAGS = "-Ssign.plist"
TOOL_NAME = ac1d

ac1d_FILES = main.mm ac1d.m
ac1d_FRAMEWORS = Foundation AVFoundation CoreFoundation UIKit AudioToolbox MediaPlayer
ac1d_PRIVATE_FRAMEWORKS = SpringBoardServices

include ~/theos/makefiles/tool.mk

export ARCHS = armv7 arm64

CFLAGS = -Wall -g
