SKIPUNZIP=1
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"

## Tee
# M346B2
DELETE_FROM_WORK_DIR "vendor" "tee"
mkdir -p "$WORK_DIR/vendor/tee"
cp -rfa "$TARGET_FIRMWARE_PATH/vendor/tee" "$WORK_DIR/vendor/tee/SM-M346B2"

# Other Models
cp -rfa "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/vendor/tee" "$WORK_DIR/vendor"

## Firmware
# M346B2
if [ ! -d "$WORK_DIR/vendor/firmware/SM-A536B" ]; then
    mkdir -p "$WORK_DIR/vendor/firmware/SM-M346B2"
    mv -f "$WORK_DIR/vendor/firmware/calliope_sram.bin" "$WORK_DIR/vendor/firmware/SM-M346B2/calliope_sram.bin"
    mv -f "$WORK_DIR/vendor/firmware/mfc_fw.bin" "$WORK_DIR/vendor/firmware/SM-M346B2/mfc_fw.bin"
    mv -f "$WORK_DIR/vendor/firmware/os.checked.bin" "$WORK_DIR/vendor/firmware/SM-M346B2/os.checked.bin"
    mv -f "$WORK_DIR/vendor/firmware/NPU.bin" "$WORK_DIR/vendor/firmware/SM-M346B2/NPU.bin"
    mv -f "$WORK_DIR/vendor/firmware/vts.bin" "$WORK_DIR/vendor/firmware/SM-M346B2/vts.bin"
    touch "$WORK_DIR/vendor/firmware/calliope_sram.bin"
    touch "$WORK_DIR/vendor/firmware/mfc_fw.bin"
    touch "$WORK_DIR/vendor/firmware/os.checked.bin"
    touch "$WORK_DIR/vendor/firmware/NPU.bin"
    touch "$WORK_DIR/vendor/firmware/vts.bin"
fi

# Other Models
cp -rfa "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/vendor/firmware" "$WORK_DIR/vendor"

## Init (init.s5e8825.unify.rc)
ADD_TO_WORK_DIR "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor" "vendor" "etc/init/init.s5e8825.unify.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"

# Sepolicy
if ! grep -q "tee_file (dir (mounton" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    echo "(allow init_31_0 tee_file (dir (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 tee_file (dir (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_fw_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_fw_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_npu_firmware_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_npu_firmware_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi

# File Context
cat "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/file_context-vendor" >> "$WORK_DIR/configs/file_context-vendor"

# Fs Config
cat "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/fs_config-vendor" >> "$WORK_DIR/configs/fs_config-vendor"

