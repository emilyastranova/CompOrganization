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
        push    {fp, lr}        @ A solution to my previous attempt at moving memory manually
        add     fp, sp, #4      @ Create our new frame by moving frame pointer

        sub     sp, sp, #8      @ Make room for 2 numbers (our parameters)
        str     r0, [fp, #-8]   @ Store our first paramter on stack (n value)
        str     r1, [fp, #-12]  @ Store second paramter (boolean)

        cmp     r0, #0          @ If n == 0
        BEQ     epilogue        @ return
        
        sub     r0, r0, #1      @ Subtract 1 from n and store n in r0

        @bl      toggleLeftMove  @ Toggle leftMove boolean
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
        ldr     r3, [fp, #-8]           @ pgmxm added
        sub     r2, r3, #1              @ pgmxm added
        ldr     r3, [fp, #-12]          @ pgmxm added
        cmp     r3, #0                  @ pgmxm added
        moveq   r3, #1                  @ pgmxm added
        movne   r3, #0                  @ pgmxm added
        uxtb    r3, r3                  @ pgmxm added
        mov     r0, r2                  @ pgmxm added
        mov     r1, r3                  @ pgmxm added
        bl      moves                   @ pgmxm added


        @ pgmxm removed cmp     r1, #0          
        @ pgmxm removed moveq   r1, #1
        @ pgmxm removed movne   r1, #0
        @ pgmxm removed uxtb    r1, r1

        @ pgmxm removed ldr     r0, [fp, #-8]   @ Store our first paramter on stack (n value)
        @ pgmxm removed ldr     r1, [fp, #-12]  @ Store second paramter (boolean)

        bl      moves           @ branch and link to moves


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
	@mov	r0, r4
    @mov     r1, #3
	@bl 	readLn

	@mov     r0, r4
	@bl 	uDecToInt

    mov     r0, #3				@ r0 holds number of disks
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

