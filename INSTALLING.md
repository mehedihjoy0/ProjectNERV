# Installing Project NERV for Samsung Galaxy M34 5G and Galaxy F34

## Requirements

- A computer or an external media with at least 6 GB of free space and exFAT format.
  - If working with an external media, exFAT format is a **must**. FAT32 has a 4 GB file size limit, which the Project NERV builds well exceed, and NTFS is read-only on the phone.
  - If working with a laptop, make sure you plug it in just in case. If you're travelling, make sure you disable sleep on lid closure just in case. Refer to your OS's/desktop environment's documentation for more info.
- [This build of TWRP](https://t.me/b_builds/91) if on Galaxy M34 5G.
- A data cable for connecting the phone to a computer if working with one.
- At least 20% of charge on the phone.
- ADB installed and fully working on the computer if working with one.
  - You can get it from either Google's website ([platform-tools](https://developer.android.com/tools/releases/platform-tools)) ([Google USB drivers for Windows](https://developer.android.com/studio/run/win-usb)) or your preferred package repository. For example, Ubuntu users can install `android-sdk-platform-tools` and add themselves to `plugdev` group while NixOS users should enable `packages.adb.enable`, add `adbusers` to `users.users.<username>.extraGroups` and perform `nixos-rebuild switch`.
- Optionally a full data backup unless you feel experimental.
- Brain, time and patience.

## Required firmware

### For Samsung Galaxy M34 5G

- M346B: M346BXUU7DYE1
- M346B2: M346B2XUU7DYE1
- M346B1: M346B1DXU7DYE1

### For Samsung Galaxy F34

E346BXUUDYE1

## Installation

Download the Project NERV firmware and the linked TWRP. Once that's done, flash the recovery from Odin and boot into it.

Also flash the required firmware as noted above beforehand.

This procedure consists of two sections. Please read each section carefully.

### If working with a computer with Platform Tools installed

Connect your phone to the computer and head over to ADB sideload.

- In TWRP, ADB sideload is under Advanced.
- In Orangefox, ADB sideload is under Menu.

Open a command prompt/terminal window (On Windows, you have to Shift+right click to reveal "Open a PowerShell window here" option) in the folder you downloaded NERV into (usually the downloads folder) and give it this command:

```
adb sideload ProjectNERV_X.Y.Z-a1b2c3d4_YYYYMMDD_device.zip
```

> [!NOTE]
> The `device` notation is `m34x` for Galaxy M34 5G and `f34x` for Galaxy F34.

> [!NOTE]
> On Windows, you might have to give full path to ADB when using ADB commands. This can be worked around by adding its folder to the "Path" variable under `sysdm.cpl` > Advanced tab > Environment variables...
>
> On Linux and macOS, you can do the same step by `export PATH=/path/to/platform-tools:$PATH`. The `:$PATH` notation here is important as that will make your shell preserve the previous PATH directories and save you from losing access to other tools. If you installed `adb` and `fastboot` from your package manager, you don't have to do this since it's already installed into a directory that's contained in your PATH variable.

If you could download and flash the required firmware beforehand, you should be able to boot into the system.

### If working with an external media

Insert or plug in your external media that has Project NERV flashable ZIP on it.

In TWRP, head over to "Install" and locate the flashable. Tap on it and swipe on the slider.

In Orangefox, you just need to locate the flashable. Tap on it and swipe on the slider.

If you could download and flash the required firmware beforehand, you should be able to boot into the system.

## Post-install steps

1. Disable RAM Plus and reboot. It's noted to hurt the performance. Quoting the release:
> **DISABLE RAM PLUS**! This kernel does not encourage using RAM Plus as it hurts performance.
2. If you want root, use [the latest release of Floppy Kernel](https://github.com/FlopKernel-Series/flop_s5e8825_kernel/releases/latest). Download the KSUNext variant and flash the ZIP in recovery.
