##
# MIT License
#
# Copyright (c) 2020 Ivan Nikolsky
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##

include ~/theos/makefiles/common.mk
export SYSROOT = /Users/teleprosheo/theos/sdks/iPhoneOS11.2.sdk
export TARGET_CODESIGN_FLAGS = "-Ssign.plist"
TOOL_NAME = ac1d

ac1d_FILES = main.mm ac1d.m
ac1d_FRAMEWORS = Foundation
ac1d_PRIVATE_FRAMEWORKS = AppSupport

include ~/theos/makefiles/tool.mk

export ARCHS = armv7 arm64

CFLAGS = -Wall -g
