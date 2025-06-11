SKIPUNZIP=1

# [
GET_DECODER_JAR()
{
    local JAR_FILE="$TOOLS_DIR/decoder.jar"
    local DOWNLOAD_URL="https://github.com/fei-ke/OmcTextDecoder/releases/download/v0.4/omc-decoder.jar"

    if [ ! -f "$JAR_FILE" ]; then
        curl -L -s -o "$JAR_FILE" "$DOWNLOAD_URL"
    fi
}

DECODE_XMLS()
{
    local DECODER_JAR="$TOOLS_DIR/decoder.jar"
    local XMLS="$(find "$WORK_DIR/optics" -type f -name "cscfeature.xml")"

    for xml in $XMLS; do
        xml_out="$(dirname "$xml")/out_cscfeature.xml"
        java -jar "$DECODER_JAR" -d -i "$xml" &> /dev/null
        rm -f "$xml"
        mv "$xml_out" "$xml"
    done
}

MODIFY_XMLS()
{
    while read xml
    do
        # Keep the country ISO blocks unchanged as they are required for the EUX and EUY CSCs
        COUNTRY_ISO="$(sed -n "/<\/FeatureSet>/,\$p" "$xml" | sed "1d;\$d")"
        [[ -n "$COUNTRY_ISO" ]] && sed -i "/<\/FeatureSet>/,\$d" "$xml"

        sed -i "/<\/FeatureSet>/d" "$xml" \
            && sed -i "/<\/SamsungMobileFeature>/d" "$xml"

        # Delete unnecessary features in TUR CSC
        if grep -q "TURKEY" "$xml"; then
            FTD="
            CscFeature_GMS_SetClientIDBaseCr
            CscFeature_GMS_SetClientIDBaseMs
            CscFeature_GMS_SetClientIDBaseVs
            CscFeature_SystemUI_ConfigOpBrandingForIndicatorIcon
            "

            for f in $FTD; do
                sed -i "/${f}/d" "$xml"
            done
        fi

        # Delete unnecessary features
        for f in $FEATURES_TO_DELETE; do
            sed -i "/${f}/d" "$xml"
        done

        # Add extra features
        for f in $FEATURES_TO_ADD; do
            FEATURE="$(echo -n "${f}" | cut -d "=" -f1)"
            VALUE="$(echo -n "${f}" | cut -d "=" -f2)"

            sed -i "/${FEATURE}/d" "$xml"
            echo "    <${FEATURE}>${VALUE}</${FEATURE}>" >> "$xml"
        done

        sed -n "/<FeatureSet>/,/<\/FeatureSet>/p" "$xml" | sed "1d;\$d" | sort > "$xml.sorted"
        sed -i "/<FeatureSet>/,/<\/FeatureSet>/d" "$xml"
        {
            echo "  <FeatureSet>"
            cat "$xml.sorted"
            echo "  </FeatureSet>"
        } >> "$xml"
        rm -f "$xml.sorted"

        # Add country ISO back if it exists
        [[ -n "$COUNTRY_ISO" ]] && echo "$COUNTRY_ISO" >> "$xml"

        echo "</SamsungMobileFeature>" >> "$xml"
    done <<< "$(find "$WORK_DIR/optics" -type f -name "cscfeature.xml")"
}

ENCODE_XMLS()
{
    local DECODER_JAR="$TOOLS_DIR/decoder.jar"
    local XMLS="$(find "$WORK_DIR/optics" -type f -name "cscfeature.xml")"

    for xml in $XMLS; do
        xml_out="$(dirname "$xml")/out_cscfeature.xml"
        java -jar "$DECODER_JAR" -e -i "$xml" &> /dev/null
        rm -f "$xml"
        mv "$xml_out" "$xml"
    done
}
# ]

FEATURES_TO_DELETE="
CscFeature_SetupWizard_SupportEsimAsPrimary
"

FEATURES_TO_ADD="
CscFeature_Audio_SupportSafeMediaVolumeDialog=TRUE
CscFeature_Calendar_SetColorOfDays=XXXXXBR
CscFeature_Camera_CameraFlicker=50hz
CscFeature_Camera_DefaultQuality=superfine
CscFeature_Camera_ShutterSoundMenu=TRUE
CscFeature_Clock_DisableIsraelCountry=TRUE
CscFeature_Contact_SupportUiccPrompt=TRUE
CscFeature_LockScreen_ConfigCarrierTextPolicy=DisplayUsimText,DisplayPlmnAtBottom
CscFeature_Message_EnableReplyAll=TRUE
CscFeature_Message_EnableSpeedDial=TRUE
CscFeature_NFC_DefStatus=OFF
CscFeature_RIL_USIMPersonalizationKOR=TRUE
CscFeature_Setting_DisableIsraelCountry=TRUE
CscFeature_Setting_EnableHwVersionDisplay=TRUE
CscFeature_Setting_SupportMenuSmartTutor=FALSE
CscFeature_Setting_SupportRealTimeNetworkSpeed=TRUE
CscFeature_SystemUI_ConfigMaxRssiLevel=5
CscFeature_SystemUI_ConfigOverrideDataIcon=LTE
CscFeature_VoiceCall_ConfigOpStyleForVolte=KOR_OPEN_VOLTE,KOR_VOLTE
CscFeature_VoiceCall_ConfigRecording=RecordingAllowed
CscFeature_Wifi_SupportAdvancedMenu=TRUE
"

GET_DECODER_JAR
DECODE_XMLS
MODIFY_XMLS

echo "Patching APKs for network speed monitoring..."

DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"
DECODE_APK "system_ext/priv-app/SystemUI/SystemUI.apk"

FTP="
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/eternal/provider/items/NotificationsItem.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/notification/ConfigureNotificationMoreSettings\$1.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/notification/StatusBarNetworkSpeedController.smali
system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/Rune.smali
system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/QpRune.smali
"
for f in $FTP; do
    sed -i "s/CscFeature_Common_SupportZProjectFunctionInGlobal/CscFeature_Setting_SupportRealTimeNetworkSpeed/g" "$APKTOOL_DIR/$f"
done