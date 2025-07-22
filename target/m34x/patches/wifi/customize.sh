LOG_STEP_IN
LOG_STEP_IN "- Decode APKs"
DECODE_APK "system" "system/framework/semwifi-service.jar"
DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"
LOG_STEP_OUT

LOG_STEP_IN "- Disable dual AP hotspot support"
APPLY_PATCH "system" "system/framework/semwifi-service.jar" "$SRC_DIR/target/$TARGET_CODENAME/patches/wifi/patches/semwifi-service.jar/0002-Disable-DualAP-support.patch"
APPLY_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" "$SRC_DIR/target/$TARGET_CODENAME/patches/wifi/patches/SecSettings.apk/0002-Disable-DualAP-support.patch"
LOG_STEP_OUT

LOG_STEP_IN "- Disable WiFi 6 hotspot support"
APPLY_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" "$SRC_DIR/target/$TARGET_CODENAME/patches/wifi/patches/SecSettings.apk/0003-Disable-Hotspot-Wi-Fi-6.patch"
LOG_STEP_OUT

LOG_STEP_IN "- Disable enhanced open hotspot security support"
APPLY_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" "$SRC_DIR/target/$TARGET_CODENAME/patches/wifi/patches/SecSettings.apk/0004-Disable-Hotspot-Enhanced-Open.patch"
LOG_STEP_OUT
LOG_STEP_OUT
