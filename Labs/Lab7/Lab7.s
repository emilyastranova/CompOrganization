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
        str fp, [sp, #-4]
        add fp, sp, #0          @ I still don't understand why we do this
        mov R0, 0               @ R0 is the sum (we output this later)
        mov R1, 0               @ R1 is the current number
addLoop: 
        add R1, R1, #2          @ Add 2 to R1 (current number). 
                                @ I do this before the check because I
                                @ interpreted the instructions as
                                @ between 0-100, exclusive (no 100)

        cmp R1, #100            @ Check if we are at 100 (1100100)
        BEQ end                 @ End program if we are, otherwise continue
        add R0, R0, R1          @ Add 2 to R0 (the sum)
        B addLoop               @ Repeat the addition and summation
end:
        add sp, fp, #0          @ do a lot of stack stuff I don't quite understand
        ldr fp, [sp], #4
        bx lr
