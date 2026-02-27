# Transfer File from PC to SD Card via U-Boot

This guide shows how to transfer a file from your PC to an SD card on VExpress board using U-Boot with TFTP and cp commands.

## Prerequisites

- VExpress board with U-Boot
- PC and board connected via Ethernet
- TFTP server running on PC
- SD card inserted in the board (with FAT partition)
- File to transfer in TFTP directory (e.g., `/srv/tftp/`)

## Setup TFTP Server on PC

### Linux:
```bash
sudo apt-get install tftpd-hpa
sudo systemctl start tftpd-hpa
sudo cp your_file /srv/tftp/
```

### Windows:
- Install Tftpd64 or similar TFTP server
- Place your file in the TFTP directory

## Method 1: Using cp Command (RAM Copy)

This method loads the file to RAM, copies it to another RAM location using `cp`, then writes to SD card.

### Steps:

```bash
# 1. Configure network in U-Boot
setenv ipaddr 192.168.1.50          # Board IP
setenv serverip 192.168.1.100       # PC IP (TFTP server)

# 2. Load file from PC to RAM via TFTP
tftp $kernel_addr_r abdo
# Note: filesize variable is automatically set

# 3. Check transferred file size
printenv filesize

# 4. Copy file to another RAM location using cp
cp.b $kernel_addr_r 0x62000000 $filesize
# This copies from kernel_addr_r to 0x62000000

# 5. Initialize SD card
mmc dev 0
mmc rescan

# 6. Write from RAM to SD card FAT partition
fatwrite mmc 0:1 0x62000000 abdo $filesize
# mmc 0:1 = device 0, partition 1
# 0x62000000 = source address (where cp copied to)
# abdo = filename on SD card
# $filesize = size to write

# 7. Verify file on SD card
fatls mmc 0:1
```

### Memory Layout:
```
RAM:
├─ $kernel_addr_r (e.g., 0x60000000)  ← TFTP loads here
│  [File data from TFTP]
│
├─ 0x62000000                          ← cp copies to here
   [Copied file data] ──────────────────→ Written to SD card
```

## Method 2: Direct Write (Without cp)

This method writes directly to SD card without using `cp` command - **faster and simpler**.

### Steps:

```bash
# 1. Configure network
setenv ipaddr 192.168.1.50
setenv serverip 192.168.1.100

# 2. Load file from PC to RAM via TFTP
tftp $kernel_addr_r abdo

# 3. Initialize SD card
mmc dev 0
mmc rescan

# 4. Write directly to SD card (skip cp step)
fatwrite mmc 0:1 $kernel_addr_r abdo $filesize
# Writes directly from kernel_addr_r to SD card

# 5. Verify
fatls mmc 0:1
```

## Comparison

| Method | Commands | Speed | Use Case |
|--------|----------|-------|----------|
| **Method 1 (with cp)** | tftp → cp → fatwrite | Slower | Learning exercise, preserve original in RAM |
| **Method 2 (direct)** | tftp → fatwrite | Faster | Production use, simpler |

## Common Commands Reference

| Command | Description |
|---------|-------------|
| `tftp <addr> <file>` | Download file from TFTP server to RAM |
| `cp.b <src> <dst> <size>` | Copy bytes in RAM from src to dst |
| `mmc dev <n>` | Select MMC/SD device number |
| `mmc rescan` | Scan and initialize SD card |
| `fatwrite mmc <dev:part> <addr> <file> <size>` | Write from RAM to FAT filesystem |
| `fatls mmc <dev:part>` | List files on FAT partition |
| `printenv <var>` | Print environment variable |

## Verification Steps

### Verify file on SD card:
```bash
fatls mmc 0:1
```

### Verify file integrity:
```bash
# Load file back from SD card to different RAM location
fatload mmc 0:1 0x70000000 abdo

# Compare with original
cmp.b $kernel_addr_r 0x70000000 $filesize
```
Expected output: `Total of XXXXX bytes were the same`

## Common File Sizes (Hex Reference)

| Size | Decimal | Hex |
|------|---------|-----|
| 1 KB | 1,024 | 0x400 |
| 64 KB | 65,536 | 0x10000 |
| 512 KB | 524,288 | 0x80000 |
| 1 MB | 1,048,576 | 0x100000 |
| 10 MB | 10,485,760 | 0xA00000 |

## Troubleshooting

### TFTP timeout:
- Check network connection
- Verify PC firewall allows TFTP (port 69)
- Ensure TFTP server is running: `sudo systemctl status tftpd-hpa`
- Verify file exists: `ls -l /srv/tftp/abdo`
- Test ping: `ping $serverip`

### SD card not detected:
- Check SD card is inserted properly
- Try: `mmc rescan`
- Check available devices: `mmc list`

### File size mismatch:
- Check `printenv filesize` after TFTP
- Ensure you use `$filesize` variable in commands
- If manual size, convert to hex correctly

## Summary

**With cp (Method 1):**
```bash
tftp $kernel_addr_r abdo
cp.b $kernel_addr_r 0x62000000 $filesize
mmc dev 0 && mmc rescan
fatwrite mmc 0:1 0x62000000 abdo $filesize
```

**Without cp (Method 2 - Recommended):**
```bash
tftp $kernel_addr_r abdo
mmc dev 0 && mmc rescan
fatwrite mmc 0:1 $kernel_addr_r abdo $filesize
```

---

**Note:** Replace IP addresses (`192.168.1.50`, `192.168.1.100`) with your actual network configuration.
