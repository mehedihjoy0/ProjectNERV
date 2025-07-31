# Only download & extract if custom-apps directory doesn't exist
if [ ! -d "$SRC_DIR/target/m51/patches/custom-apps/system" ]; then
    echo "Downloading & extracting custom-apps from OneUI 7..."
    wget "https://gitlab.com/mh506370/firmware/-/raw/main/custom-apps.7z"
    7z x -y "custom-apps.7z" "-o/$SRC_DIR/target/m51/patches/custom-apps"
    rm -f "custom-apps.7z"
fi
