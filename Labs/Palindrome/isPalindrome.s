@ toLower.s
@ Converts all alpha characters to lowercase.
@ Calling sequence:
@       r0 <- address of string to be written
@       r1 <- length of word or phrase
@       bl    isPalindrome
@ returns true or false in R0
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified         @ modern syntax

@ Useful source code constants
    .equ    lowerMask,0x20
    .equ    NUL,0

@ The code
    .text
    .align  2
    .global isPalindrome
    .type   isPalindrome, %function
isPalindrome:
    sub     sp, sp, 16      @ space for saving regs
    str     r4, [sp, 0]     @ save r4
    str     r5, [sp, 4]     @      r5
    str     fp, [sp, 8]     @      fp
    str     lr, [sp, 12]    @      lr
    add     fp, sp, 12      @ set our frame pointer

    mov     r2, #0
    sub     r3, r1, #1

loop:
    ldrb    r4, [r0, r2]    @ r4 holds first char
    ldrb    r5, [r0, r3]    @ r5 holds last char 

    cmp     r4, r5
    bne     notPalindrome

    add     r2, r2, #1      @ increment
    sub     r3, r3, #1      @ decrement

    cmp     r2, r3
    ble     loop

    mov     r0, 1           @ result == true
    b       epilogue

notPalindrome:
    mov     r0, 0

epilogue:
    ldr     r4, [sp, 0]     @ restore r4
    ldr     r5, [sp, 4]     @         r5
    ldr     fp, [sp, 8]     @         fp
    ldr     lr, [sp, 12]    @         lr
    add     sp, sp, 16      @ restore sp
    bx      lr              @ return
