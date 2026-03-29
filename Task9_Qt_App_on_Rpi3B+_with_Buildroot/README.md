
i

# Qt6 Calculator App on Raspberry Pi 3 B+ using Buildroot

## 📋 Project Overview

Deployed a Qt6 QML calculator application on a Raspberry Pi 3 B+ (64-bit)
using a custom Buildroot Linux image. The app runs directly on the
framebuffer without any desktop environment (no X11, no Wayland).

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│         Qt6 Calculator App          │  ← QML/QtQuick UI
├─────────────────────────────────────┤
│        Qt6 (EGLFS/LinuxFB)         │  ← Qt Platform Abstraction
├─────────────────────────────────────┤
│     Mesa3D (OpenGL ES2) + DRM      │  ← Graphics Stack
├─────────────────────────────────────┤
│   VC4-FKMS GPU Driver (kernel)     │  ← RPi GPU Driver
├─────────────────────────────────────┤
│   Linux Kernel 6.12 (aarch64)      │  ← 64-bit kernel
├─────────────────────────────────────┤
│      Buildroot Root Filesystem     │  ← Minimal embedded Linux
├─────────────────────────────────────┤
│    Raspberry Pi 3 Model B+ HW     │  ← Target Hardware
└─────────────────────────────────────┘
```

---

## 🔧 Build System Details

| Component             | Choice                          |
|-----------------------|---------------------------------|
| Build System          | Buildroot 2026.02               |
| Target Board          | Raspberry Pi 3 B+ (64-bit)      |
| Defconfig             | `raspberrypi3_64_defconfig`     |
| Toolchain             | External (glibc, aarch64)       |
| Kernel                | Linux 6.12.61-v8                |
| Qt Version            | Qt6 (Base + Declarative + ShaderTools) |
| Graphics Driver       | VC4-FKMS-V3D (via dtoverlay)   |
| GPU Userspace         | Mesa3D (VC4 + V3D Gallium)      |
| Display Backend       | EGLFS with KMS / LinuxFB        |

---

## 📁 Project Structure

```
buildroot/
├── board/raspberrypi3-64/
│   ├── config_3_64bit.txt       # RPi boot config (modified)
│   └── rootfs-overlay/
│       └── etc/
│           ├── init.d/
│           │   └── S99qtcalculator  # Auto-start script
│           └── qt_kms.conf          # KMS display config
│
├── package/itisimplecal/
│   ├── Config.in                # Buildroot package config
│   ├── itisimplecal.mk          # Buildroot package makefile
│   ├── CMakeLists.txt           # CMake build (QRC approach)
│   ├── main.cpp                 # App entry point
│   ├── Main.qml                 # Main calculator UI
│   ├── CalcButton.qml           # Reusable button component
│   └── resources.qrc            # Qt resource file
```

---

## 🔑 Key Technical Decisions & Challenges

### 1. QML Module Loading: `loadFromModule` vs QRC
- **Problem:** Qt6's `qt_add_qml_module()` + `engine.loadFromModule()` requires
  host QML compiler tooling that is very hard to set up for cross-compilation.
- **Solution:** Converted to **QRC (Qt Resource System)** approach using
  `engine.load(QUrl("qrc:/Main.qml"))`. Simple and reliable for cross-compilation.

### 2. GPU Driver: Full KMS vs Fake KMS
- **Problem:** `dtoverlay=vc4-kms-v3d` (full KMS) loaded only HVS component.
  HDMI, pixelvalves, and V3D failed to bind. No `/dev/dri/` was created.
- **Root Cause:** Full KMS requires all DRM components to bind as a component
  master. On RPi 3 with this kernel, it failed silently.
- **Solution:** Switched to `dtoverlay=vc4-fkms-v3d` (Fake KMS). FKMS
  delegates rendering to the VideoCore firmware and is more compatible with RPi 3.
  After loading modules, `/dev/dri/card0` and `/dev/dri/renderD128` appeared.

### 3. Kernel Modules Not Auto-Loading
- **Problem:** VC4/V3D/DRM are compiled as **kernel modules** (.ko), not
  built-in. They were not loaded at boot.
- **Solution:** Created `/etc/modules-load.d/vc4.conf` with:
  ```
  drm
  v3d
  vc4
  ```

### 4. Boot Config (`config.txt`)
- **Problem:** Buildroot cached the rpi-firmware package, so our edited
  `config_3_64bit.txt` was NOT applied to the final image.
- **Solution:** Manually edited `/boot/config.txt` on the RPi after first boot.
  For future builds: run `make rpi-firmware-dirclean && make` to force rebuild.

### 5. Locale Issue
- **Problem:** Qt6 requires UTF-8 locale. Buildroot's minimal system only has
  `C` locale (ANSI).
- **Solution:** `export LANG=C.UTF-8 && export LC_ALL=C.UTF-8` before running.

---

## 📝 Boot `config.txt` (Critical Settings)

```ini
start_file=start.elf
fixup_file=fixup.dat
kernel=Image
disable_overscan=1
gpu_mem_256=128
gpu_mem_512=128
gpu_mem_1024=256
dtoverlay=miniuart-bt
arm_64bit=1

# GPU: Fake KMS (more compatible with RPi 3)
dtoverlay=vc4-fkms-v3d
max_framebuffers=2

# Force HDMI even without monitor at boot
hdmi_force_hotplug=1
```

---

## 🚀 How to Run

### Build (on host PC):
```bash
cd buildroot/
make raspberrypi3_64_defconfig   # Start with RPi3 64-bit config
make menuconfig                   # Enable Qt6, Mesa, itisimplecal
make                              # Build everything
```

### Flash:
```bash
sudo dd if=output/images/sdcard.img of=/dev/sdX bs=4M status=progress
sync
```

### Run on RPi (manual):
```bash
# Load GPU drivers
modprobe drm
modprobe v3d
modprobe vc4
sleep 3

# Set environment
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms
export QT_QPA_EGLFS_KMS_ATOMIC=1
export XDG_RUNTIME_DIR=/tmp/runtime-root
mkdir -p /tmp/runtime-root

# Launch
itisimplecal
```

---

## 🎤 Points

1. **Cross-compilation:** Built ARM64 binary on x86 host using Buildroot's
   external toolchain and CMake cross-compilation toolchain file.

2. **Buildroot package system:** Created a custom package with `.mk` file
   (using `cmake-package` infrastructure), `Config.in` for Kconfig, and
   `local` site method to include source directly.

3. **Graphics stack on embedded Linux:** Mesa3D provides OpenGL ES2 via
   Gallium VC4/V3D drivers → DRM/KMS → Qt EGLFS platform plugin renders
   directly to display without X11 or Wayland.

4. **FKMS vs KMS:** Full KMS talks directly to hardware. FKMS uses RPi's
   VideoCore firmware as intermediary. FKMS is simpler and more reliable
   on RPi 3, while full KMS is preferred on RPi 4+.

5. **Qt Platform Plugins:** Qt abstracts display through QPA (Qt Platform
   Abstraction). `eglfs` renders via OpenGL ES directly to DRM. `linuxfb`
   writes to `/dev/fb0`. No window manager needed.

6. **Device Tree Overlays:** RPi firmware reads `config.txt` at boot, applies
   device tree overlays (`.dtbo` files) to enable/configure hardware like GPU
   drivers before the kernel starts.

7. **Root filesystem overlay:** Buildroot copies files from
   `BR2_ROOTFS_OVERLAY` directory into the final rootfs, allowing custom
   configs and scripts without modifying Buildroot core.

---

## 📦 Buildroot Config Highlights (`make menuconfig`)

```
Target: AArch64 (cortex-a53)
Toolchain: External (glibc)
Kernel: bcm2711 defconfig (works for RPi3 64-bit too)
DTB: bcm2710-rpi-3-b, bcm2710-rpi-3-b-plus, bcm2710-rpi-cm3

Packages enabled:
  - qt6base (GUI, EGLFS, LinuxFB, OpenGL ES2, Widgets, Network)
  - qt6declarative (QML engine)
  - qt6shadertools (required for Qt Quick rendering)
  - mesa3d (Gallium VC4 + V3D, EGL, OpenGL ES, GBM)
  - libdrm (VC4)
  - itisimplecal (our custom package)
```

---

## 🎬 Demo Video
[![Watch Demo Video](https://img.shields.io/badge/▶_Watch_Demo-Google_Drive-4285F4?style=for-the-badge&logo=googledrive&logoColor=white)](https://drive.google.com/file/d/1a1pItTd9iTavIjDuibz_QnEQVS2L7UEG/view?usp=drive_link)

> **[Click here to watch the full demo video on Google Drive](https://drive.google.com/file/d/1a1pItTd9iTavIjDuibz_QnEQVS2L7UEG/view?usp=drive_link)**


## Author
**Abdelfattah**
