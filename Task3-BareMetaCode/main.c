/*===========================================================================
 * File:        main.c
 * Author:      Abdelfattah
 * Target:      Raspberry Pi 3B+ (BCM2837 SoC)
 * Description: Bare-metal LED blinker application for AArch64
 *              
 *              This program blinks an LED connected to GPIO 26.
 *              It directly manipulates GPIO registers without any OS.
 *              Loaded and executed via U-Boot bootloader.
 *
 * Hardware:    
 *              - Raspberry Pi 3B+
 *              - LED connected to GPIO 26 (Pin 37 on header)
 *              - 330Ω resistor in series with LED
 *
 * GPIO Config:
 *              - GPIO 26 configured as OUTPUT via GPFSEL2
 *              - LED ON:  Write to GPSET0
 *              - LED OFF: Write to GPCLR0
 *
 * Memory Map:
 *              - GPIO Base Address: 0x3F200000
 *              - GPFSEL2: 0x3F200008 (Function Select for GPIO 20-29)
 *              - GPSET0:  0x3F20001C (Pin Output Set)
 *              - GPCLR0:  0x3F200028 (Pin Output Clear)
 *
 * Build:       aarch64-linux-gnu-gcc -c main.c -o main.o -ffreestanding
 * 
 * Notes:       - Function name is 'abdelfattah' to match startup.s entry
 *              - Uses volatile pointers for hardware register access
 *              - Never returns (infinite loop)
 *===========================================================================*/

#include "BCM2837_GPIO.h"

/*---------------------------------------------------------------------------
 * delay() - Simple software delay
 * 
 * Parameters:  count - Number of loop iterations
 * Returns:     None
 * 
 * Note:        Uses volatile to prevent compiler optimization
 *---------------------------------------------------------------------------*/
void delay(unsigned int count)
{
    volatile unsigned int i = count;
    while (i--)
        ;
}

/*---------------------------------------------------------------------------
 * GPIO Register Pointers
 * 
 * volatile: Prevents compiler from optimizing away register reads/writes
 *---------------------------------------------------------------------------*/
volatile unsigned int *GPFSEL2 = (volatile unsigned int *)BCM2837_GPFSEL2;
volatile unsigned int *GPSET0 = (volatile unsigned int *)BCM2837_GPSET0;
volatile unsigned int *GPCLR0 = (volatile unsigned int *)BCM2837_GPCLR0;

/*---------------------------------------------------------------------------
 * abdelfattah() - Main application entry point
 * 
 * Called from startup.s after stack initialization.
 * Configures GPIO 26 as output and blinks LED forever.
 * 
 * Parameters:  None
 * Returns:     Never returns (infinite loop)
 *---------------------------------------------------------------------------*/
int abdelfattah(void)
{
    /* Configure GPIO 26 as OUTPUT
     * GPFSEL2 bits [20:18] control GPIO 26
     * Value 001 = Output mode
     */
    *GPFSEL2 &= ~(0b111 << 18);  // Clear bits [20:18]
    *GPFSEL2 |=  (0b001 << 18);  // Set as output (001)

    /* Infinite blink loop */
    while (1)
    {
        /* Turn LED ON - Set GPIO 26 HIGH */
        *GPSET0 = (1 << 26);
        delay(100000);

        /* Turn LED OFF - Set GPIO 26 LOW */
        *GPCLR0 = (1 << 26);
        delay(100000);
    }

    return 0;  // Never reached
}