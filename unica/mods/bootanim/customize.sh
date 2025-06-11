TWOTHREE_TARGETS=""
TWOFOUR_TARGETS="a52sxq a73xq m52xq r8q r9q r9q2"

if echo "$TWOTHREE_TARGETS" | grep -q -w "$TARGET_CODENAME"; then
    cp -a --preserve=all "$SRC_DIR/unica/mods/bootanim/2340x1080/"* "$WORK_DIR/system/system/media"
elif echo "$TWOFOUR_TARGETS" | grep -q -w "$TARGET_CODENAME"; then
    cp -a --preserve=all "$SRC_DIR/unica/mods/bootanim/2400x1080/"* "$WORK_DIR/system/system/media"
else
    echo "Unknown boot animation resolution for \"$TARGET_CODENAME\""
fi

echo "Adding S25 Sounds"
DELETE_FROM_WORK_DIR "system" "system/media/audio"
ADD_TO_WORK_DIR "pa1qxx" "system" "system/media/audio"