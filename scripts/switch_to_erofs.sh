#!/usr/bin/env bash
#
# Copyright (C) 2025 saadelasfur
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

if [ "$#" == 0 ]; then
    echo "Usage: switch_to_erofs <image>" >&2
    exit 1
fi

if [ ! -f "$1" ]; then
    LOGE "File not found: $1"
    exit 1
fi

if [[ "$1" == *"vendor_boot"* ]]; then
    IMG="$WORK_DIR/kernel/vendor_boot.img"
    FSTAB_DIR="ramdisk/first_stage_ramdisk"
else
    IMG="$WORK_DIR/kernel/boot.img"
    FSTAB_DIR="ramdisk"
fi

IMG_FILE="${IMG#"$WORK_DIR/kernel/"}"
IMG_OUT="${IMG_FILE%.img}_new.img"

[ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

mv "$IMG" "$TMP_DIR"
cd "$TMP_DIR"

avbtool erase_footer --image "$IMG_FILE"
magiskboot unpack -h "$IMG_FILE"
mkdir ramdisk && cd ramdisk
cpio -id < "../ramdisk.cpio"
rm -f "$TMP_DIR/$FSTAB_DIR/fstab"* \
    && cp "$SRC_DIR/target/$TARGET_CODENAME/patches/erofs/vendor/etc/fstab"* "$TMP_DIR/$FSTAB_DIR"
find . | cpio -o -H newc > "../ramdisk_new.cpio"
cd ..
rm -f ramdisk.cpio && mv ramdisk_new.cpio ramdisk.cpio
rm -rf ramdisk
magiskboot repack "$IMG_FILE" "$IMG_OUT"
mv "$TMP_DIR/$IMG_OUT" "$IMG"

rm -rf "$TMP_DIR"
cd - &> /dev/null

exit 0
