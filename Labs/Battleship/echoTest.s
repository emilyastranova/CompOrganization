	.arch armv6
	.text
	.align	2
	.global	main
	.arch armv6
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function
	.section	.rodata

inputString:
	.asciz	"%d, %d\000"
	.align	2
testOut:
	.asciz	"You inputted: x = %d, y = %d\n"
	.text
	
main:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8

	sub	r2, fp, #12
	sub	r3, fp, #8
	mov	r1, r3
	ldr	r0, inputStringAddr
	bl	scanf
	
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-12]
	mov	r1, r3
	ldr	r0, testOutAddr
	bl	printf
	
	mov	r0, #0
	
	sub	sp, fp, #4
	pop	{fp, pc}

inputStringAddr:
	.word	inputString
testOutAddr:
	.word	testOut
