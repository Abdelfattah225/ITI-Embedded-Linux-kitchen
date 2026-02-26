/* extern */
.global _start

_start:
    ldr     x0, =0x60100000     // Stack at load address
    mov     sp, x0              // Stack grows DOWN toward 0x60000000

    bl      abdelfattah

_return:
    b _return