#============================================================================
# Makefile for Bare-Metal LED Blinker
# Target: Raspberry Pi 3B+ (AArch64)
# Author: Abdelfattah
#============================================================================

# Toolchain
CROSS_COMPILE = aarch64-linux-gnu-
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy

# Output filename
TARGET = abdelfattah_blinky

# Source files
ASM_SRC = startup.s
C_SRC = main.c

# Object files
ASM_OBJ = $(ASM_SRC:.s=.o)
C_OBJ = $(C_SRC:.c=.o)

# Linker script
LINKER_SCRIPT = linker.ld

# Compiler flags
CFLAGS = -ffreestanding -nostdlib -nostartfiles -O2

# Assembler flags
ASFLAGS =

# Linker flags
LDFLAGS = -T $(LINKER_SCRIPT) -nostdlib

#============================================================================
# Build Rules
#============================================================================

# Default target
all: $(TARGET).img

# Assemble startup.s → startup.o
$(ASM_OBJ): $(ASM_SRC)
	$(AS) $(ASFLAGS) $< -o $@

# Compile main.c → main.o
$(C_OBJ): $(C_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Link → app.elf
$(TARGET).elf: $(ASM_OBJ) $(C_OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

# Convert ELF → binary image
$(TARGET).img: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@
	@echo ""
	@echo "========================================="
	@echo "Build complete: $(TARGET).img"
	@echo "========================================="
	@echo "Load address: 0x60100000"
	@echo ""
	@echo "U-Boot commands:"
	@echo "  fatload mmc 0:1 0x60100000 $(TARGET).img"
	@echo "  go 0x60100000"
	@echo "========================================="

# Clean build files
clean:
	rm -f *.o *.elf *.img

# Phony targets
.PHONY: all clean