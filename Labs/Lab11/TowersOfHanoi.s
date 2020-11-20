@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Useful source code constant
        .equ    STDOUT,1

@ Constant program data
        .section  .rodata
        .align  2
.data

prompt: .asciz  "Enter number of game disks: \n"
left: .asciz   "%d left\n"
right: .asciz   "%d right\n"
false: .asciz "false\n"
true: .asciz "true\n"

@ Program code
        .text
        .align  2
        .global main
        .type   main, %function
main:
        push    {r4, fp, lr}    @ prologue. Save Frame Pointer and LR onto the stack */
	add     fp, sp, #4      @ prologue. set up the bottom of our stack frame */
        mov     r0, #3
        bl      malloc          @ Get memory from the heap
        mov     r4, r0
        ldr     r0, promptAddr  @ Prompt user for input
        bl      printf

	@ read and convert input to int, store in r0
	mov	r0, r4
        mov     r1, #3
	bl 	readLn

	mov     r0, r4
	bl 	uDecToInt

        @mov     r0, #3          @ Constant 3 instead of user input for now
                                @ Register 0 is our arg1 (n value) for moves()
                                @ Register 1 is our arg2 (the boolean) for moves()
        mov     r1, #1          @ Test make true
        
        bl      moves           @ branch and link to moves
        
        mov     r0, r4          @ Put memory address in r0 to use free
        bl      free            @ Free memory from the heap

        pop     {r4, fp, pc}    @ Pop everything off the stack

moves:
        push    {fp, lr}        @ A solution to my previous attempt at moving memory manually
        add     fp, sp, #4      @ Create our new frame by moving frame pointer

        sub     sp, sp, #8      @ Make room for 2 numbers (our parameters)
        str     r0, [fp, #-8]   @ Store our first paramter on stack (n value)
        str     r1, [fp, #-12]  @ Store second paramter (boolean)

        cmp     r0, #0          @ If n == 0
        BEQ     endMoves        @ return
        
        sub     r0, r0, #1      @ Subtract 1 from n and store n in r0

        cmp     r1, #0
        moveq   r1, #1
        movne   r1, #0
        uxtb    r1, r1

        bl      moves           @ branch and link to moves
        
        cmp     r1, #1          @ If left, print that, otherwise print right
        BEQ     printLeft
        B       printRight  

if:
	ldr     r1, [fp, #-8]
	ldr     r3, [fp, #-12]				@ if (leftMove)
	cmp     r3, #1
	beq 	printLeft

printRight:
        ldr     r0, rightAddr
        ldr     r1, [fp, #-8]
        bl      printf
        b       endif

printLeft:
        ldr     r0, leftAddr
        ldr     r1, [fp, #-8]
        bl      printf
        b       endif
endif:
        ldr     r3, [fp, #-8]            
        sub     r2, r3, #1               
        ldr     r3, [fp, #-12]           
        cmp     r3, #0                   
        moveq   r3, #1                   
        movne   r3, #0                   
        uxtb    r3, r3                   
        mov     r0, r2                   
        mov     r1, r3                   
        bl      moves                   

endMoves:                       @ No clue what to do here, this is potentially where my problem is
	sub	sp, fp, #4
	pop	{fp, pc}

leftAddr: .word   left
rightAddr: .word  right
promptAddr: .word   prompt
falseAddr: .word false
trueAddr: .word true 
