# ITI-Embedded-Linux-kitchen

A collection of Embedded Linux Tasks demonstrating step-by-step progress from fundamental system concepts to building and deploying complex graphical applications on hardware like the Raspberry Pi 3B+ and QEMU virtual environments.

## 🚀 Repository Contents

This repository is organized into several lab tasks, each focusing on a specific part of the Embedded Linux stack:

### Task 1: File System & Virtual SD Card
* **Focus:** Disk images, partitioning, and formatting.
* **Description:** Created a 1 GiB virtual SD card image using `dd`, explored MBR vs GPT partitioning schemes, formatted a FAT16 bootable partition, and set up an EXT4 root filesystem.

### Task 2: U-Boot Build and Deployment
* **Focus:** Bootloader concepts and building U-Boot.
* **Description:** Built U-Boot for the Raspberry Pi 3B+ and explored the unique GPU-first boot sequence (BootROM -> bootcode.bin -> start.elf -> U-Boot -> Kernel).

### Task 3: Bare-Metal Code
* **Focus:** Low-level hardware control without an OS.
* **Description:** Wrote bare-metal code to blink an LED on the Raspberry Pi 3B+ (GPIO 26) by directly controlling memory registers and loading the program via U-Boot.

### Task 4: U-Boot TFTP to SD Card
* **Focus:** Network loading and file transfers.
* **Description:** Explored different methods (RAM copy and direct write) to transfer a file from a PC to an SD card on a VExpress board via U-Boot and TFTP.

### Task 5: Booting Linux Kernel on RPi 3B+
* **Focus:** Cross-compiling the Linux Kernel.
* **Description:** Cross-compiled the Linux Kernel (`aarch64`) and successfully booted it on the Raspberry Pi 3B+ via U-Boot until reaching a Kernel Panic (due to the intentional absence of a rootfs).

### Task 6: Build & Boot Custom Kernel
* **Focus:** Custom Kernel configurations.
* **Description:** Built a mainline Linux Kernel from source, added a custom personal signature to the kernel version, and booted it via a U-Boot bootscript on QEMU `vexpress-A9`.

### Task 7: Initramfs with BusyBox
* **Focus:** Early boot environments and minimal filesystems.
* **Description:** Created a minimal initramfs (Initial RAM Filesystem) from scratch using a statically linked `dash` shell and later integrated BusyBox. Successfully booted it to a functional interactive shell prompt.

### Task 8: Dual Partition Selection
* **Focus:** Custom Boot Menu and initramfs scripting.
* **Description:** Designed a custom initramfs that acts as a boot menu. It prompts the user to select between two different root filesystem partitions during boot and uses `switch_root` to hand off control.

### Task 9: Qt App on RPi3B+ with Buildroot
* **Focus:** Embedded graphics and Buildroot.
* **Description:** Created a custom Buildroot Linux image and deployed a Qt6 QML calculator app on a Raspberry Pi 3B+ using the framebuffer (EGLFS/LinuxFB) without a desktop environment (No X11/Wayland).

### Task 10: Systemd Boot Design for Qt Weather App
* **Focus:** systemd services, targets, and dependencies.
* **Description:** Designed a robust systemd boot sequence for a Qt Weather Application. Ensured the app only starts after networking is configured (static IP), loop devices are mounted, and the environment preparation script succeeds.

---

## 🛠️ Tools & Technologies Used
* **Languages:** C, C++, QML, Shell, Makefile, CMake
* **Build Systems & Compilers:** Buildroot, Cross-Compilers (crosstool-NG, `aarch64`, `arm-cortexa9`), Make
* **Target Hardware/Emulators:** Raspberry Pi 3B+, QEMU (`vexpress-a9`)
* **Bootloaders & OS:** U-Boot, Linux Kernel, systemd, BusyBox
