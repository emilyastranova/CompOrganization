	.arch armv6

	@ Constant program data
        .section  .rodata
        .align  2
leftMsg:
        .asciz   "%d left\n"

rightMsg:
        .asciz   "%d right\n"

promptDisks:
        .asciz        "Enter the number of disks: \n"



	@ Program code
	.text
	.align	2
        .global main
        .type   main, %function
        .type   moves, %function

moves:
	push	{fp, lr}				@ moves prologue
	add	fp, sp, #4

	sub	sp, sp, #8				@ push r0, r1 onto stack
	str	r0, [fp, #-8]				@ [fp -8] <- n
	str	r1, [fp, #-12]				@ [fp -12] <- leftMove

	ldr	r3, [fp, #-8]				@ if (n == 0)
	cmp	r3, #0					@	return
	beq	epilogue

	ldr	r3, [fp, #-8]				@ r3 <- n
	sub	r2, r3, #1				@ r2 <- n - 1
	ldr	r3, [fp, #-12]				@ r3 <- leftMove
	cmp	r3, #0					@ r3 <- !leftMove					
	moveq	r3, #1
	movne	r3, #0
	uxtb	r3, r3					@ clear 24 of 32 bits
	mov     r0, r2					@ r0 <- n-1
	mov	r1, r3					@ r1 <- !leftMove
	bl	moves

if:
	ldr     r1, [fp, #-8]
	ldr     r3, [fp, #-12]				@ if (leftMove)
	cmp     r3, #1
	bne 	printRight

printLeft:
        ldr     r0, leftMsgAddr				@ output n, " left "
	ldr     r1, [fp, #-8]          				@ argument for printf
        bl      printf						
	b	endif

printRight:	
	ldr     r0, rightMsgAddr                 	@ output n, " right "
        ldr     r1, [fp, #-8]                          	@ argument for printf
        bl      printf 					@ output n. " right "
endif:


	ldr	r3, [fp, #-8]
	sub	r2, r3, #1
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	moveq	r3, #1
	movne	r3, #0
	uxtb	r3, r3
	mov	r0, r2
	mov	r1, r3
	bl	moves

epilogue:
	sub	sp, fp, #4
	pop	{fp, pc}

main:
	push	{r4, fp, lr}
	add	fp, sp, #8

        mov     r0, #3      	@ get memory from heap
        bl      malloc
        mov     r4, r0          @ pointer to new memory

	ldr     r0, promptAddr                        
        bl      printf   

	@ read and convert input to int, store in r0
	mov	r0, r4
        mov     r1, #3
	bl 	readLn

	mov     r0, r4
	bl 	uDecToInt

        @mov     r0, #3				@ r0 holds number of disks
	mov	r1, #1				@ r1 holds leftMove == true
	bl	moves

	mov 	r0, r4
	bl	free

	pop	{r4, fp, pc}


leftMsgAddr:
        .word   leftMsg

rightMsgAddr:
        .word   rightMsg

promptAddr:
        .word    promptDisks

