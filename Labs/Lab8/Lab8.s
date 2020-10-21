@ Objective: Sum all even numbers from 1-100

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Useful source code constant
        .equ    STDOUT,1

@ Constant program data
        .section  .rodata
        .align  2
@ Program code
        .text
        .align  2
        .global main
        .type   main, %function
main:
        push {r11, lr}          @ prologue. Save Frame Pointer and LR onto the stack */
	add r11, sp, #0         @ prologue. set up the bottom of our stack frame */
        sub sp, sp, #12         @ Make room for 2 numbers
        mov R0, 0               @ R0 is the sum (we output this later)
        mov R1, 0               @ R1 is the current number
        str R0, [fp, #-8]       @ Set mem val 1 to 0 (sum)
        str R1, [fp, #-12]      @ Set mem val 2 to 0 (current num)
addLoop: 
        ldr R0, [fp, #-8]       @ Load mem val 1 into R0
        ldr R1, [fp, #-12]      @ Load mem val 2 into R1
        add R1, R1, #2          @ Add 2 to R1 (current number). 
                                @ I do this before the check because I
                                @ interpreted the instructions as
                                @ between 0-100, exclusive (no 100)
        str R1, [fp, #-12]      @ Set mem val 2 to 0 (current num)
        ldr R1, [fp, #-12]      @ Load mem val 2 into R1
        cmp R1, #100            @ Check if we are at 100 (1100100)
        BEQ end                 @ End program if we are, otherwise continue
        add R0, R0, R1          @ Add 2 to R0 (the sum)
        str R0, [fp, #-8]       @ Set mem val 2 to 0 (current num)
        ldr R0, [fp, #-8]       @ Load mem val 2 into R1
        B addLoop               @ Repeat the addition and summation
end:
        add sp, fp, #0          @ Reset the stack pointer
        ldr fp, [sp], #4
        bx lr
