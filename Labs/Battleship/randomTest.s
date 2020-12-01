	.arch armv6
	.text
	.align	2
	.global	main
	.arch armv6
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

	mov	r0, #0
	bl	time

	bl	srand
	mov	r3, #0
	str	r3, [fp, #-8]
	bl	rand

	mov	r2, r0
	ldr	r3, .L3
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
	ldr	r3, [fp, #-8]
	mov	r0, r3

	sub	sp, fp, #4
	pop	{fp, pc}
.L3:
	.word	1717986919
