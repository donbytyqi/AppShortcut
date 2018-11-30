THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 arm64
TARGET = iphone:clang
# TARGET = simulator:clang::7.0
# ARCHS = x86_64 i386
# i386 slice is required for 32-bit iOS Simulator (iPhone 5, etc.)
DEBUG = 0
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppShortcut
AppShortcut_FRAMEWORKS = UIKit
AppShortcut_FILES = AppShortcut.xm
AppShortcut_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AppShortcut_LIBRARIES = applist

BUNDLE_NAME = com.donbytyqi.appshortcut
com.donbytyqi.appshortcut_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS)/makefiles/bundle.mk

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += appshortcut
include $(THEOS_MAKE_PATH)/aggregate.mk
