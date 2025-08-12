# Only download & extract if media directory doesn't exist
if [ ! -d "$SRC_DIR/target/m51/patches/media/system" ]; then
    echo "Downloading & extracting media from OneUI 7..."
    wget -q "https://gitlab.com/mh506370/firmware/-/raw/main/media.7z"
    7z x -y "media.7z" "-o/$SRC_DIR/target/m51/patches/media"
    rm -f "media.7z"
fi
