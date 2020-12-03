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
horizontal: .asciz   "Ship Direction: horizontal\n"
vertical: .asciz   "Ship Direction: vertical\n"
inputString:
	.asciz	"%d, %d\000"
	.align	2
testOut:
	.asciz	"You inputted: x = %d, y = %d\n"
	.text
randOut: .asciz "Random number is: %d\n"
xIs: .asciz "X [fp, #%d]: %d, "
yIs: .asciz "Y [fp, #%d]: %d\n"
hitText: .asciz "You hit the enemy! You win!\n"
missText: .asciz "You missed! Try again...\n\n"
titleText: .asciz "\r\n  ____       _______ _______ _      ______  _____ _    _ _____ _____  \r\n |  _ \\   /\\|__   __|__   __| |    |  ____|/ ____| |  | |_   _|  __ \\ \r\n | |_) | /  \\  | |     | |  | |    | |__  | (___ | |__| | | | | |__) |\r\n |  _ < / /\\ \\ | |     | |  | |    |  __|  \\___ \\|  __  | | | |  ___/ \r\n | |_) / ____ \\| |     | |  | |____| |____ ____) | |  | |_| |_| |     \r\n |____/_/    \\_\\_|     |_|  |______|______|_____/|_|  |_|_____|_|     \r\n                                                                      \r\n(Lame Edition)\nBy: Tyler Harrison\n\n\n"

@ Program code
    .text
    .align  2
    .global main
    .type   main, %function

getGuesses:
    @prologue
    push    {fp, lr}        @ prologue. Save Frame Pointer and LR onto the stack */
	add     fp, sp, #4      @ prologue. set up the bottom of our stack frame */
    str     r0, [fp, #-40]   @ Store address of x in memory
    str     r1, [fp, #-44]  @ Store address of y in memory

    @ Print out prompt
    ldr     r0, promptAddr
    bl      printf

	ldr	    r1, [fp, #-40]   @ Load x address into arg1
	ldr	    r2, [fp, #-44]  @ Load y address into arg2
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

	ldr		r0, titleAddr		@ Print "BATTLESHIP" title
	bl		printf			

	bl 		generateRandBool	@ Determine whether we go horizontal or vertical
	str		r1, [fp, #-4]		@ Store on the stack
	cmp		r1, #1				@ If odd, horizontal
	sub		sp, sp, #48			@ Make room for 10 numbers, boolean
	beq	horizontalCond
	bne	verticalCond


horizontalCond:
	ldr		r0, horizontalAddr	@ Print horizontal
	bl		printf
    bl      generateRandInt6    @ Generate a random number between 0-6 and put in r1 (x)
	str		r1, [fp, #-8]		@ Store first x value
	ldr     r0, randOutAddr
    bl      printf

	bl      generateRandInt9    @ Generate a random number between 0-9 and put in r1 (y)
	str		r1, [fp, #-12]		@ Store first x value
	ldr     r0, randOutAddr
    bl      printf

	ldr		r0, [fp, #-8]		@ Load registers back
	ldr		r1, [fp, #-12]		
	mov		r3, #-16			@ Setting up loop number

hLoop:
	cmp		r3, #-36			@ Check if we're at end of gen
	ble		printArray			@ End if so
	add		r0, r0, #1			@ Make x move + 1
	str		r0, [fp, r3]		@ Store x value
	sub		r3, r3, #4			@ Move our index
	str		r1, [fp, r3]		@ Store y (doesnt change)
	sub		r3, r3, #4			@ Move our index
	b		hLoop

verticalCond:
	ldr		r0, verticalAddr	@ Print vertical
	bl		printf
    bl      generateRandInt6    @ Generate a random number between 0-6 and put in r1 (x)
	str		r1, [fp, #-8]		@ Store first x value
	ldr     r0, randOutAddr
    bl      printf

	bl      generateRandInt9    @ Generate a random number between 0-9 and put in r1 (y)
	str		r1, [fp, #-12]		@ Store first x value
	ldr     r0, randOutAddr
    bl      printf

	ldr		r0, [fp, #-8]		@ Load registers back
	ldr		r1, [fp, #-12]		
	mov		r3, #-16			@ Setting up loop number

vLoop:
	cmp		r3, #-36			@ Check if we're at end of gen
	ble		printArray			@ End if so
	str		r0, [fp, r3]		@ Store x (doesn't change)
	sub		r3, r3, #4			@ Move our index
	add		r1, r1, #1			@ Make y move + 1
	str		r1, [fp, r3]		@ Store y
	sub		r3, r3, #4			@ Move our index
	b		vLoop

printArray:
	mov		r3, #-8			@ Setting up loop number
printLoop:
	cmp		r3, #-36			@ Check if we're at end of gen
	ble		getUserInput
	ldr		r0, xIsAddr
	mov		r1, r3
	ldr		r2, [fp, r3]
	str		r3,	[fp, #-4]
	bl		printf
	ldr		r3,	[fp, #-4]

	sub		r3, r3, #4
	ldr		r0, yIsAddr
	mov		r1, r3
	ldr		r2, [fp, r3]
	str		r3,	[fp, #-4]
	bl 		printf
	ldr		r3,	[fp, #-4]
	sub		r3, r3, #4
	b 		printLoop

getUserInput:
    @ Print out prompt
    ldr     r0, promptAddr
    bl      printf

    sub     r0, fp, #40     	@ Store address of fp -40 in r0 (x)
    sub     r1, fp, #44     	@ Store address of fp -44 in r1 (y)
    str     r0, [fp, #-40]  	@ Store address of x in memory
    str     r1, [fp, #-44]  	@ Store address of y in memory

	ldr	    r1, [fp, #-40]   	@ Load x address into arg1
	ldr	    r2, [fp, #-44]  	@ Load y address into arg2
	ldr	    r0, inputStringAddr @ Load address of string into scanf arg0
	bl	    scanf

	ldr	    r1, [fp, #-40]		@ Load x back into r1
	ldr	    r2, [fp, #-44]		@ Load y back into r2
	ldr	    r0, testOutAddr
	bl	    printf

checkCoords:
	mov		r3, #-8			@ Setting up loop number
	ldr	    r1, [fp, #-40]
	ldr	    r2, [fp, #-44]
xLoop:
	cmp		r3, #-36		@ Check if we're at end of gen
	ble		miss		@ End if no luck with x
	ldr		r0, [fp, r3]	@ Load in x val for check
	sub		r3, r3, #8		@ Hop in memory (index)
	cmp		r1,	r0			@ Compare x with x guess
	beq		yCheck
	bne		xLoop

yCheck:
	sub		r3, r3, #4
	ldr		r0, [fp, r3]	@ Load in y val for check
	sub		r3, r3, #4
	cmp		r2,	r0			@ Compare x with x guess
	beq		hit
	bne		xLoop

miss:
	ldr		r0, missAddr
	bl		printf
	b 		getUserInput

hit:
	ldr		r0, hitAddr
	bl		printf

epilogue:
	sub		sp, fp, #4
	pop		{fp, pc}

promptAddr: .word   prompt
horizontalAddr: .word  horizontal
verticalAddr: .word   vertical
testOutAddr: .word testOut
inputStringAddr: .word inputString
randOutAddr: .word randOut
randKey6: .word	-1840700269
randKey9: .word	1717986919
xIsAddr: .word xIs
yIsAddr: .word yIs
titleAddr: .word titleText
hitAddr: .word hitText
missAddr: .word missText
