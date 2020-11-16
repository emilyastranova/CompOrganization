@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Useful source code constant
        .equ    STDOUT,1

@ Constant program data
        .section  .rodata
        .align  2


prompt:
        .asciz  "Enter number of game disks: "
left:
        .asciz   "left"
format: 
        .asciz "%s"
string: 
        .asciz "Output: %s\n"
storage: 
        .space 80          @ --- added buffer

.text
.global main
main:                       @ --- removed .
    push {r11, lr}          @ prologue. Save Frame Pointer and LR onto the stack */
	add r11, sp, #0         @ prologue. set up the bottom of our stack frame */
    sub sp, sp, #12         @ Make room for 2 numbers
    ldr r0, promptAddr     /*loading address of prompt message in r0*/
    bl printf               /*calling printf*/

    ldr r0, addr_format     /*loading first parameter of scanf*/
    ldr r1, addr_storage    @ --- location to write data from input
    bl scanf                /*calling scanf*/

    /*below I am trying to print out the user
    input from scanf*/

    ldr r1, addr_storage    @ --- data location
    ldr r0, addr_string     @ --- printf format
    bl printf

    add sp, fp, #0          @ Reset the stack pointer
    pop {fp, pc}

promptAddr: .word prompt
addr_format: .word format
addr_string: .word string
addr_storage: .word storage @ --- address of buffer
