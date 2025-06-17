#
# Copyright (C) 2025 Ksawlii
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

# Device configuration file for Exynos 1280 (s5e8825)
TARGET_NAME="Galaxy M34 5G"
TARGET_CODENAME="m34x"
TARGET_ASSERT_MODEL=("SM-$TARGET_MODEL")
if [ "$TARGET_MODEL" == "M346B2" ]; then
  TARGET_FIRMWARE="SM-M346B2/TUR/353903640123459" # IMEI taken from Bifrost.
elif [ "$TARGET_MODEL" == "M346B" ]; then
  TARGET_FIRMWARE="SM-M346B/INS/350785781234564" # IMEI taken from Bifrost.
elif [ "$TARGET_MODEL" == "M346B1" ]; then
  TARGET_FIRMWARE="SM-M346B1/XEO/353257871234562" # IMEI taken from Bifrost.
fi
TARGET_PLATFORM="exynos1280"
TARGET_PRODUCT_FIRST_API_LEVEL=31
TARGET_EXTRA_FIRMWARES=()
TARGET_API_LEVEL=34
TARGET_VENDOR_API_LEVEL=31
TARGET_SINGLE_SYSTEM_IMAGE="essi"
TARGET_OS_FILE_SYSTEM="erofs"
TARGET_SUPER_PARTITION_SIZE=11744051200
TARGET_SUPER_GROUP_SIZE=11739856896
TARGET_HAS_SYSTEM_EXT=false
TARGET_DISABLE_AVB_SIGNING=true

# SEC Product Feature
TARGET_FP_SENSOR_CONFIG="google_touch_display_side,settings=3"
TARGET_SSRM_CONFIG_NAME="siop_m34x_s5e8825"
TARGET_MDNIE_SUPPORTED_MODES="37905"
TARGET_AUDIO_SUPPORT_ACH_RINGTONE=false
TARGET_AUDIO_SUPPORT_DUAL_SPEAKER=true
TARGET_AUDIO_SUPPORT_VIRTUAL_VIBRATION=false
TARGET_AUTO_BRIGHTNESS_TYPE="5"
TARGET_DVFS_CONFIG_NAME="dvfs_policy_s5e8825_xx"
TARGET_HAS_HW_MDNIE=false
TARGET_HAS_MASS_CAMERA_APP=true
TARGET_HAS_QHD_DISPLAY=false
TARGET_HFR_MODE="2"
TARGET_HFR_SUPPORTED_REFRESH_RATE="60,120"
TARGET_HFR_DEFAULT_REFRESH_RATE="120"
TARGET_IS_ESIM_SUPPORTED=false
TARGET_MDNIE_WEAKNESS_SOLUTION_FUNCTION="3"
TARGET_MULTI_MIC_MANAGER_VERSION="07010"
TARGET_SUPPORT_CUTOUT_PROTECTION=false
