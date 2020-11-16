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
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%d\000"
	.align	2
.LC1:
	.ascii	" left \000"
	.align	2
.LC2:
	.ascii	" right \000"
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
	sub	sp, sp, #8
	str	r0, [fp, #-8]
	mov	r3, r1
	strb	r3, [fp, #-9]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	beq	.L6
	ldr	r3, [fp, #-8]
	sub	r2, r3, #1
	ldrb	r3, [fp, #-9]	@ zero_extendqisi2
	cmp	r3, #0
	movne	r3, #1
	moveq	r3, #0
	uxtb	r3, r3
	eor	r3, r3, #1
	uxtb	r3, r3
	and	r3, r3, #1
	uxtb	r3, r3
	mov	r1, r3
	mov	r0, r2
	bl	moves
	ldrb	r3, [fp, #-9]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L4
	ldr	r1, [fp, #-8]
	ldr	r0, .L7
	bl	printf
	ldr	r0, .L7+4
	bl	puts
	b	.L5
.L4:
	ldr	r1, [fp, #-8]
	ldr	r0, .L7
	bl	printf
	ldr	r0, .L7+8
	bl	puts
.L5:
	ldr	r3, [fp, #-8]
	sub	r2, r3, #1
	ldrb	r3, [fp, #-9]	@ zero_extendqisi2
	cmp	r3, #0
	movne	r3, #1
	moveq	r3, #0
	uxtb	r3, r3
	eor	r3, r3, #1
	uxtb	r3, r3
	and	r3, r3, #1
	uxtb	r3, r3
	mov	r1, r3
	mov	r0, r2
	bl	moves
	b	.L1
.L6:
	nop
.L1:
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L8:
	.align	2
.L7:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.size	moves, .-moves
	.section	.rodata
	.align	2
.LC3:
	.ascii	"Enter number of game disks: \000"
	.align	2
.LC4:
	.ascii	"%s\000"
	.align	2
.LC5:
	.ascii	"done\000"
	.text
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
	ldr	r1, .L11
	ldr	r0, .L11+4
	bl	printf
	sub	r3, fp, #8
	mov	r1, r3
	ldr	r0, .L11+8
	bl	__isoc99_scanf
	ldr	r3, [fp, #-8]
	mov	r1, #1
	mov	r0, r3
	bl	moves
	ldr	r0, .L11+12
	bl	puts
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L12:
	.align	2
.L11:
	.word	.LC3
	.word	.LC4
	.word	.LC0
	.word	.LC5
	.size	main, .-main
	.ident	"GCC: (Raspbian 8.3.0-6+rpi1) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
