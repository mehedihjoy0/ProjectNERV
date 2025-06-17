if [[ -d "$SRC_DIR/target/$TARGET_CODENAME/overlay" ]]; then
    if [[ "$TARGET_SINGLE_SYSTEM_IMAGE" == "qssi" ]]; then
        SOURCE="dm1qxxx"
    elif [[ "$TARGET_SINGLE_SYSTEM_IMAGE" == "essi" ]]; then
        SOURCE="r11sxxx"
    fi

    DECODE_APK "product" "overlay/framework-res__${SOURCE}__auto_generated_rro_product.apk"

    echo "Applying stock overlay configs"
    rm -rf "$APKTOOL_DIR/product/overlay/framework-res__${SOURCE}__auto_generated_rro_product.apk/res"
    cp -a --preserve=all \
        "$SRC_DIR/target/$TARGET_CODENAME/overlay" \
        "$APKTOOL_DIR/product/overlay/framework-res__${SOURCE}__auto_generated_rro_product.apk/res"
fi