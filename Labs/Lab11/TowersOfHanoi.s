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

prompt: .asciz  "Enter number of game disks: "
left: .asciz   "left"
format: .asciz "%s"
string: .asciz "Output: %s\n"
storage: .space 80          @ --- added buffer
false: .asciz "false\n"
true: .asciz "true\n"

@ Program code
        .text
        .align  2
        .global main
        .type   main, %function
main:
        push    {r11, lr}       @ prologue. Save Frame Pointer and LR onto the stack */
	add     r11, sp, #0     @ prologue. set up the bottom of our stack frame */
        sub     sp, sp, #12     @ Make room for r3 and r4
        str     r3, [sp, 4]     @ save r3
        @str     r4, [sp, 8]     @ save r4 (our memory counter)
        @mov     r4, #12         @ Memory counter begins at 12

        mov     r3, #3          @ Constant 3 instead of user input for now
                                @ Register 0 is our arg1 (n value) for moves()
                                @ Register 1 is our arg2 (the boolean) for moves()
        @mov     r1, #0          @ Test make true
        
        @bl      toggleLeftMove  @ Toggle leftMove boolean value
        bl      moves

        ldr     r4, [sp, 4]     @ Restore r3
        ldr     r4, [sp, 8]     @ Restore r4
        add     sp, fp, #0      @ Reset the stack pointer
        pop     {fp, pc}

moves:
        cmp     r0, #0          @ If n == 0
        BEQ     endMoves        @ return
        sub     r0, r0, #1      @ Subtract 1 from n and store n in r0
        bl      toggleLeftMove  @ Toggle leftMove boolean
        sub     sp, sp, #4      @ Make some room in memory
        str     lr, [sp, 4]     @ Store link register
        @add     r4, #4          @ Move memory counter for storing lr
        bl      moves           @ branch and link to moves
        bl      moves           @ branch and link to moves

endMoves:
        ldr     lr, [sp, 4]    @ Load last link register from memory
        add     sp, sp, #4     @ Add 4 to stack pointer to point to next link register
        bx lr

toggleLeftMove:
        cmp r1, #1
        BEQ turnLeftMoveFalse
        b turnLeftMoveTrue
        bx  lr

turnLeftMoveFalse:
        mov r1, #0
        bx lr

turnLeftMoveTrue:
        mov r1, #1
        bx lr

getInput:
        ldr     r0, promptAddr
        bl      printf

        ldr     r0, addr_format     @ Loading first parameter of scanf
        ldr     r1, addr_storage    @ Location to write data from input
        bl      scanf               @ Calling scanf

        ldr     r1, addr_storage    @ data location
        ldr     r0, addr_string     @ printf format
        bl      printf   

leftAddr: .word   left
promptAddr: .word   prompt
addr_format: .word format
addr_string: .word string
addr_storage: .word storage         @ --- address of buffer
falseAddr: .word false
trueAddr: .word true
