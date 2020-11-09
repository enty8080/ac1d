include /Users/teleprosheo/theos/makefiles/common.mk

TWEAK_NAME = ac1d
ac1d_FILES = Tweak.xm
ac1d_PRIVATE_FRAMEWORKS = AppSupport

include /Users/teleprosheo/theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
