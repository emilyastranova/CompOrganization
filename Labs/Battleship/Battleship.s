@ Define my Raspberry Pi
    .cpu    cortex-a53
    .fpu    vfp
    .arch   armv6
    .syntax unified         @ modern syntax
    .arm

@ Useful source code constant
    .equ    STDOUT,1
    .equ    nBytes, 16

@ Constant program data
    .section  .rodata
    .align  2
    .data

prompt: .asciz  "Input a coordinate to try and hit (x,y): \n"
horizontal: .asciz   "horizontal\n"
vertical: .asciz   "vertical\n"
directionTest: .asciz "direction is %d\n"
inputString:
	.asciz	"%d, %d\000"
	.align	2
testOut:
	.asciz	"You inputted: x = %d, y = %d\n"
	.text
randOut: .asciz "Random number is: %d\n"

@ Program code
    .text
    .align  2
    .global main
    .type   main, %function

getGuesses:
    @prologue
    push    {fp, lr}        @ prologue. Save Frame Pointer and LR onto the stack */
	add     fp, sp, #4      @ prologue. set up the bottom of our stack frame */
    
    sub     sp, sp, #8      @ Make room for r0 and r1 address for input
    str     r0, [fp, #-8]   @ Store address of x in memory
    str     r1, [fp, #-12]  @ Store address of y in memory

    @ Print out prompt
    ldr     r0, promptAddr
    bl      printf

	ldr	    r1, [fp, #-8]   @ Load x address into arg1
	ldr	    r2, [fp, #-12]  @ Load y address into arg2
	ldr	    r0, inputStringAddr @ Load address of string into scanf arg0
	bl	    scanf
	
	sub	    sp, fp, #4
	pop	    {fp, pc}

@ Puts random number between 0-9 in r1
generateRandInt9:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8

	mov	r0, #0
	bl	time

	bl	srand
	mov	r3, #0
	str	r3, [fp, #-8]
	bl	rand

	mov	r2, r0
	ldr	r3, randKey9
	smull	r1, r3, r3, r2
	asr	r1, r3, #2
	asr	r3, r2, #31
	sub	r1, r1, r3
	mov	r3, r1
	lsl	r3, r3, #2
	add	r3, r3, r1
	lsl	r3, r3, #1
	sub	r3, r2, r3
	str	r3, [fp, #-8]
    mov r1, r3
	sub	sp, fp, #4
	pop	{fp, pc}

@ Puts random number between 0-6 in r1
generateRandInt6:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8

	mov	r0, #0
	bl	time

	bl	srand
	mov	r3, #0
	str	r3, [fp, #-8]
	bl	rand

	mov	r2, r0
	ldr	r3, randKey6
	smull	r1, r3, r3, r2
	add	r3, r3, r2
	asr	r1, r3, #2
	asr	r3, r2, #31
	sub	r1, r1, r3
	mov	r3, r1
	lsl	r3, r3, #3
	sub	r3, r3, r1
	sub	r3, r2, r3
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-8]
	mov	r1, r3

	sub	sp, fp, #4
	pop	{fp, pc}

@ Generates a 1 or a 0 randomly
generateRandBool:
		push	{fp, lr}
		add		fp, sp, #4
		mov 	r0, #0
		bl		time
        tst 	R0, #1  	@ test whether r0 is odd
        MOVEQ  	r1, #1 		@ if odd, set r1 to 1
        MOVNE  	r1, #0		@ if even, set r1 to 0
		sub		sp, fp, #4
		pop		{fp, pc}

main:
    push    {fp, lr}        @ prologue. Save Frame Pointer and LR onto the stack */
	add     fp, sp, #4      @ prologue. set up the bottom of our stack frame */
    sub     sp, sp, #8      @ Make room for r0 and r1 address for input

    sub     r0, fp, #8      @ Store address of fp -8 in r0 (x)
    sub     r1, fp, #12     @ Store address of fp -8 in r1 (y)

    bl      getGuesses

	ldr	    r1, [fp, #-8]
	ldr	    r2, [fp, #-12]
	ldr	    r0, testOutAddr
	bl	    printf

	bl 		generateRandBool	@ Determine whether we go horizontal or vertical
	cmp		r1, #1				@ If odd, horizontal
	ldreq	r0, horizontalAddr
	ldrne	r0, verticalAddr
	bl 		printf

	sub		sp, sp, #32			@ Make room for 8 numbers

horizontalCond:
    bl      generateRandInt6    @ Generate a random number between 0-6 and put in r1 (x)
	str		r1, [fp, #-8]		@ Store first x value
	ldr     r0, randOutAddr
    bl      printf

	bl      generateRandInt9    @ Generate a random number between 0-9 and put in r1 (y)
	str		r1, [fp, #-12]		@ Store first x value
	ldr     r0, randOutAddr
    bl      printf

    @ epilogue
	sub	    sp, fp, #4
	pop	    {fp, pc}

promptAddr: .word   prompt
horizontalAddr: .word  horizontal
verticalAddr: .word   vertical
directionAddr: .word directionTest
testOutAddr: .word testOut
inputStringAddr: .word inputString
randOutAddr: .word randOut
randKey6: .word	-1840700269
randKey9: .word	1717986919
