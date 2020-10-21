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

        mov R0, 25              @ R0 is the buffer
        str R0, [fp, #-8]       @ Set mem val 1 to 25
        mov R0, 13              @ Change to 13 to store second value
        str R0, [fp, #-12]      @ Set mem val 2 to 13

        ldr R0, [fp, #-8]       @ Load mem val 1 into R0
        ldr R1, [fp, #-12]      @ Load mem val 2 into R1  
        b min

min:
	cmp R1, R0              @ if(R1 < R0)
	movlt R0, R1            @ if true, store r1 into r0 to be returned
        b end

end:
        add sp, fp, #0          @ Reset the stack pointer
        ldr fp, [sp], #4
        bx lr
