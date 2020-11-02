@ lowerCase.s
@ Prompts user to enter alphabetic characters, converts
@ all uppercase to lowercase and shows the result.
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified         @ modern syntax

@ Constant for assembler
    .equ    nBytes,50  @ amount of memory for string
@ Constant program data
    .section .rodata
    .align  2
prompt:
    .asciz      "Enter some alphabetic characters: "

isPalindromeStr:
    .asciz      " is a palindrome."

isNotPalindromeStr:
    .asciz      " is not a palindrome."


@ The program
    .text
    .align  2
    .global main
    .type   main, %function
main:
    sub     sp, sp, 16      @ space for saving regs
                            @ (keeping 8-byte sp align)
    str     r4, [sp, 4]     @ save r4
    str     r5, [sp, 8]     @ save r5
    str     fp, [sp, 12]    @      fp
    str     lr, [sp, 16]    @      lr
    add     fp, sp, 12      @ set our frame pointer
        
    mov     r0, nBytes      @ get memory from heap
    bl      malloc
    mov     r4, r0          @ pointer to new memory

    ldr     r0, promptAddr  @ prompt user
    bl      writeStr

    mov     r0, r4          @ get user input
    mov     r1, nBytes      @ limit input size
    bl      readLn
    mov     r5, r0          @ length of string
       
    mov	    r0, r4	    @ convert to lowercase
    bl	    toLower

    mov     r0, r4          @ echo user input
    bl      writeStr

    mov     r0, r4          @ pointer to string
    mov     r1, r5          @ length of string
    bl      isPalindrome

    cmp     r0, 0           @ Test if palindrome
    beq     notPalindrome

    ldr     r0, isPalindromeAddr
    b       writeMsg

notPalindrome:
    ldr     r0, isNotPalindromeAddr

writeMsg:
    bl      writeStr
    bl      newLine

    mov     r0, r4          @ free heap memory
    bl      free

    mov     r0, 0           @ return 0;
    ldr     r4, [sp, 4]     @ restore r4
    ldr     r4, [sp, 8]     @ restore r5
    ldr     fp, [sp, 12]    @         fp
    ldr     lr, [sp, 16]    @         lr
    add     sp, sp, 16      @ restore sp
    bx      lr              @ return

promptAddr:
    .word    prompt

isPalindromeAddr:
    .word   isPalindromeStr

isNotPalindromeAddr:
    .word   isNotPalindromeStr
