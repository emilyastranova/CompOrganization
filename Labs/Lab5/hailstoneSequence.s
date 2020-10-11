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
        mov  R0, 5         @ R0 is current number
        mov  R1, 0         @ R1 is count of number of iterations

again:
   ADD  R1, R1, #1     @ increment number of iterations
        ANDS R4, R0, #1     @ test whether R0 is odd
        BEQ  even
        ADD  R0, R0, R0, LSL #1 @ if odd, set R0 = R0 + (R0 << 1) + 1
        ADD  R0, R0, #1     @ and repeat (guaranteed R0 > 1)
        B    again
even:
    MOV  R0, R0, ASR #1 @ if even, set R0 = R0 >> 1
        SUBS R7, R0, #1     @ and repeat if R0 != 1
        BNE  again
halt:
    B    halt           @ infinite loop to stop computation