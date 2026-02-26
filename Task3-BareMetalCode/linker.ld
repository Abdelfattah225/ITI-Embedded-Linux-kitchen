/*===========================================================================
 * File:        linker.ld
 * Author:      Abdelfattah
 * Target:      Raspberry Pi 3B+ (BCM2837 SoC)
 * Description: Linker script for bare-metal AArch64 application
 *
 * Load Address: 0x60100000
 *   - Matches U-Boot kernel_addr_r variable
 *   - Within DRAM range (0x60000000 - 0x80000000)
 *   - U-Boot command: fatload mmc 0:1 0x60100000 app.img
 *   - Execute command: go 0x60100000
 *
 * Memory Layout:
 *   0x60100000  → .text   (code)
 *               → .rodata (read-only data)
 *               → .data   (initialized data)
 *               → .bss    (uninitialized data)
 *===========================================================================*/

ENTRY(_start)

SECTIONS
{
    . = 0x60100000;
    
    .text : {
        *(.text)
        *(.text.*)
    }
    
    .rodata : {
        *(.rodata)
        *(.rodata.*)
    }
    
    .data : {
        *(.data)
        *(.data.*)
    }
    
    __bss_start = .;
    .bss : {
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }
    __bss_end = .;
}