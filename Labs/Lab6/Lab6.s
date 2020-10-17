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
        mov R0, 0               @ R0 is the result
        mov R1, 0               @ R1 is the n2, we will flip flop
        mov R2, 1               @ R0 is the n1
        mov R4, 0               @ R4 is our counter (n)
        mov R5, 9               @ Our nth term variable (setting to 9 outputs 34)

addLoop: 
        cmp R4, R5              @ Check if we are at the value in R5 (or catch a greater than in case)
        BGE end                 @ End program if we are, otherwise continue
        add R2, R2, R1          @ Add R1 to R2 (n). 
        mov R0, R2              @ Store our number in R0
        add R4, R4, #1          @ Increment counter by 1
        cmp R4, R5              @ Check if we are at the value in R5 (or catch a greater than in case)
        BGE end                 @ End program if we are, otherwise continue
        add R1, R2, R1          @ Add R2 to R1 (n-1)
        mov R0, R1              @ Store our number in R0
        add R4, R4, #1          @ Increment counter by 1
        B addLoop               @ Repeat the addition and summation
end:
        add sp, fp, #0          @ do a lot of stack stuff I don't quite understand
        ldr fp, [sp], #4
        bx lr
