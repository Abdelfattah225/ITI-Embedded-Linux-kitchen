# Embedded Linux Labs:

## Lab 2: Creating a Virtual SD Card for Embedded Linux Development

---

### 1- Create a 1 GiB Virtual Disk Image and explain the command you use.

```bash
dd if=/dev/zero of=sd.image bs=1M count=1024
```

**Output:**

```
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.617021 s, 1.7 GB/s
```

**Explanation:**

I used `dd` (directory destroy). The options are:

- `if` (input file) is `/dev/zero` — this is a kernel driver. Its function, when called by `cat` or any other command, will execute. If we imagine what is inside this driver:
  ```c
  int main() {
      while (1) {
          print("^@");
      }
  }
  ```
- `of` (output file) — the file I need to put data inside, which is my file `sd.image`.
- `bs` — block size: the size of each chunk when transferring data.
- `count` — the number of block-size chunks to transfer.

So this command creates the size that I need. I think it may transfer data from memory to another without changing the timestamp.

---

### 2- Define what is the difference between the DOS/MBR and GPT partition scheme/type.

I think DOS/MBR is the older version. I don't know GPT partition scheme.

---

### 3- Define what is the difference between different File Systems and their usage (FAT16, FAT32, and EXT4).

A file system is a software driver protocol used for communication between components inside the PC.

- **FAT16** is the most important communication protocol used for communication between the BIOS and the Bootloader, or when trying to load anything from an SD card.

---

### 4- Formatting and Partition the Virtual Disk Image.

```bash
sudo cfdisk sd.image
```

```
[sudo] password for abdo:
Syncing disks.
```

#### a. First primary partition (200M + bootable + FAT16)

Done.

#### b. Second primary partition (rest of the available space + EXT4)

Done.

---

### 5- Define what are Loop Devices and why Linux uses them.

Loop devices are used to give us the feature to create virtual memory.

#### a. Command to create a loop device

```bash
losetup -f -P --show sd.img
```

#### b. Command to list all loop devices currently in use

```bash
losetup -a
```

#### c. Command to detach a (mounted) loop device

```bash
losetup -d sd.img
```

---

### 6- How can you check the current loop device limit?

The limit is defined according to MBR, so when running `lsblk` it shows us which location starts and ends for processing.

---

### 7- Can you expand the number of loop devices in Linux?

Actually, we can't because every PC has limited loop devices.

---

### 8- Attach the Virtual Disk Image as a Loop Device.

*(Expected output not provided)*

---

### 9- Format the Virtual Disk Image Partitions — "Explain the command you use"

```bash
mkfs.vfat -n boot -F 16 /dev/loop8p1
```

#### a. First primary partition (Boot partition → FAT16, label "boot")

Done.

#### b. Second primary partition (ext4, label "rootfs")

I don't know.

---

### 10- Explain what you know about the "mount" and "unmount" Linux Command.

`mount` maps hardware registers to a folder so you can read, write, or execute from or to them.

---

### 11- What is the difference between a block device vs a character device?

I don't know.

---

### 12- Create Mount Points and Mount the Virtual Disk Image Partitions.

*(Answer not provided)*
