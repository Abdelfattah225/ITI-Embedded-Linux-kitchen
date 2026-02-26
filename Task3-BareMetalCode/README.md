# Bare-Metal LED Blinker On RPI3 b+ 


## Idea
This project blinks an LED on Raspberry Pi 3B+ **without any operating system**.

We directly control GPIO registers in memory to turn the LED ON and OFF. The program is loaded into RAM using U-Boot bootloader and executed from there.

---

## How It Works
```
┌─────────────────┐
│   U-Boot        │
│   loads .img    │
│   to 0x60100000 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   startup.s     │
│   - Setup stack │
│   - Call main   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   main.c        │
│   - GPIO config │
│   - Blink loop  │
│   (forever)     │
└─────────────────┘
```

---

## Files
| File | Purpose |
|------|---------|
| `startup.s` | Entry point, stack setup |
| `main.c` | GPIO control, blink logic |
| `BCM2837_GPIO.h` | GPIO register addresses |
| `linker.ld` | Memory layout |
| `Makefile` | Build automation |

---

## Hardware
- Raspberry Pi 3B+
- LED + 330Ω resistor on **GPIO 26** (Pin 37)

---

## Build
```bash
make clean
make
```

---

## Run (U-Boot)
```bash
fatload mmc 0:1 0x60100000 abdelfattah_blinky.img
go 0x60100000
```

---

## Author
**Abdelfattah**
```
