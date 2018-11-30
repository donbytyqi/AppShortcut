

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = appshortcut
appshortcut_FILES = adsRootListController.m
appshortcut_INSTALL_PATH = /Library/PreferenceBundles
appshortcut_FRAMEWORKS = UIKit MessageUI
appshortcut_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/appshortcut.plist$(ECHO_END)
