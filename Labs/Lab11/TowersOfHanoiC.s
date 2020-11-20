	.arch armv6
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"TowersOfHanoi.c"
	.text
	.align	2
	.global	moves
	.arch armv6
	.syntax unified
	.arm
	.fpu vfp
	.type	moves, %function
moves:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	
	sub	sp, sp, #8			@ Make room for 2 numbers
	str	r0, [fp, #-8]		@ Store n in memory [-8]
	mov	r3, r1				@ Store boolean in r3
	strb	r3, [fp, #-9]	@ Store boolean in memory
	ldr	r3, [fp, #-8]		@ Load n into r3

	cmp	r3, #0				@ See if n is 0 yet
	beq	.L4					@ If it is, activate L4
	
	ldr	r3, [fp, #-8]		@ Load n into r3 again
	sub	r2, r3, #1			@ Subtract n-1 and put in r2
	ldrb	r3, [fp, #-9]	@ Get boolean back into r3
	
	cmp	r3, #0				@ Toggle
	movne	r3, #1
	moveq	r3, #0
	uxtb	r3, r3
	eor	r3, r3, #1
	uxtb	r3, r3
	and	r3, r3, #1
	uxtb	r3, r3
	
	mov	r1, r3				@ Move boolean into r1
	mov	r0, r2				@ Move n to r0
	bl	moves

	ldr	r3, [fp, #-8]		@ Load n into r3
	sub	r2, r3, #1			@ Subtract n-1 and put in r2
	ldrb	r3, [fp, #-9]	@ Get boolean back into r3
	
	cmp	r3, #0				@ Toggle
	movne	r3, #1
	moveq	r3, #0
	uxtb	r3, r3
	eor	r3, r3, #1
	uxtb	r3, r3
	and	r3, r3, #1
	uxtb	r3, r3
	
	mov	r1, r3				@ Move boolean into r1
	mov	r0, r2				@ Move n into r0
	bl	moves
	b	.L1
.L4:
	nop
.L1:
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	moves, .-moves
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r3, #3
	str	r3, [fp, #-8]
	mov	r1, #1
	ldr	r0, [fp, #-8]
	bl	moves
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	main, .-main
	.ident	"GCC: (Raspbian 8.3.0-6+rpi1) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
