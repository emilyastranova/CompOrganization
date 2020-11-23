@import java.util.Scanner;
    @ publics class TowersOfHanoi
    @ {
    @	public static void moves(int n, boolean leftMove)
    @	{
    @		system.out.println( “n = “ + n + ” leftMove = “ + leftMove );	
    @		if (n == 0)		//base case
    @			{
    @			return;
    @			}
    @		moves{n-1, !leftMove);          //If I have not reached the base case, I must call a smaller version of myself with the oposite. THIS changes from true to flase, or false to true with its pair on line 25.
    @		if (leftMove)
    @			{
    @			System.out.println( n + “  left “);	//outputs the number of disks to move & in what directions
    @			}
    @		else
    @			{
    @			System.out.println( n = “ right “);
    @			}
    @		moves(n-1, !leftMove);          //If I have not reached the base case, I must call a smaller version of myself with the oposite. if the flag is true, turn it to false.
    @	}
    @	public static void main(String[] args)
    @	{
    @		int n;
    @		Scanner myInput = new Scanner( System.in );
    @		System.out.print( “Enter number of game disks: “);
    @		n = myInput.nextInt();
    @		moves(n, true);
    @		System.out.println(“done”);
    @	}
    @ }

@Start
    .arch       armv6
    
@ Constant data
    .section    .rodata
    .align      2

leftMsg:
    .asciz		"%d left\n"

rightMsg:
    .asciz		"%d right\n"

promptDisks:
	.asciz		"Enter the number of disks: \n"

@ The code
        .text
        .align 2
	    .global     main
	    .type	    main, %function
	    .type	    action, %function
	    .type	    leftMove, %function

action: 
	push    {fp, lr}            @ moves prologue
    add     fp, sp, #4

    sub     sp, sp, #8          @ push r0, r1 onto stack
    str     r0, [fp, #-8]       @ [fp -8] <- n
    str     r1, [fp, #-12]      @ [fp -12] <- leftMove
        
    ldr     r3, [fp, #-8]       @ if (n == 0)
    cmp     r3, #0              @       return
    beq     epilogue

    ldr     r3, [fp, #-8]       @ r3 <- n
    sub     r2, r3, #1          @ r2 <- n-1
	@bl		leftMove
    ldr		r3, [fp, #-12]      @ r3 <- ! leftMove ; @this resets r3 to 1 for some reason causing it to loop
    cmp		r3, #0		@ compare with a 0
	moveq	r3, #1		@ if it is a 0, "flip it" to a 1
	movne	r3, #0		@ if it is a 1, "flip it" to a 0
	uxtb	r3, r3		@ make sure all the other are 0's except for r3
	mov		r4, r3		@ assign r3 back to r4
	bl		action

	ldr     r1, [fp, #-8]
    ldr     r3, [fp, #-12]      @ if (leftMove)
    cmp     r3, #1
    bne     printRight

printLeft:
	 ldr     r0, leftMsgAddr     @ output n, " left "
     ldr     r1, [fp, #-8]           @ argument for printf
     bl      printf
     b       endif

printRight:
    ldr     r0, rightMsgAddr    @output n, " right "
    ldr     r1, [fp, #-8]           @ argument for printf
    bl      printf

endif:
    ldr     r3, [fp, #-8]       @ r2 <- n-1
    sub     r2, r3, #1
	@bl		leftMove
    ldr     r3, [fp, #-12]      @ r3 <- ! leftMove
    cmp		r3, #0		@ compare with a 0
	moveq	r3, #1		@ if it is a 0, "flip it" to a 1
	movne	r3, #0		@ if it is a 1, "flip it" to a 0
	uxtb	r3, r3		@ make sure all the other are 0's except for r3
	mov		r4, r3		@ assign r3 back to r4
    bl      action

epilogue:
	sub     sp, fp, #4
    pop     {fp, pc}

leftMove:
    ldr		r3, [fp, #-12]      @ r3 <- ! leftMove
 	mov		r3, #1		@ regester
	cmp		r3, #0		@ compare with a 0
	moveq	r3, #1		@ if it is a 0, "flip it" to a 1
	movne	r3, #0		@ if it is a 1, "flip it" to a 0
	uxtb	r3, r3		@ make sure all the other are 0's except for r3
	mov		r4, r3		@ assign r3 back to r4

main:
    push    {r4, fp, lr}        @store the LinkRester to pop out of this
    add     fp, sp, #8

    mov     r0, #3          @ get memory from heap; store up to 2 digits, store 3 bytes
    bl      malloc          
    mov     r4, r0          @ pointer to new memory

    ldr     r0, promptAddr
    bl      printf

    @ read and convert input to int, store in r0
    mov     r0, r4          @ wants the address in r0
    mov     r1, #3          @ wants the length of the address in r1; should be a constant
    bl      readLn

    mov     r0, r4        
    bl      uDecToInt     @ uDecToInt did not work for some reason. Made new file and copy paste, works now

    @                    @ r0 holds number of disks
    mov     r1, #1          @ r1 holds leftMove == true
    bl      action

    mov     r0, r4
    bl      free

    pop     {r4, fp, pc}

leftMsgAddr:
    .word   leftMsg

rightMsgAddr:
    .word   rightMsg

promptAddr:
    .word   promptDisks

