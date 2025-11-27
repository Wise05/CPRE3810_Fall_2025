.data
array:  .word 9, 3, 7, 1, 8, 2, 6, 4
n:  	.word 8
temp:   .space 32
newline: .asciiz "\n"

.text
.globl main

main:
 jal x0, major   

mergesort:
	addi x2, x2, -28
	sw   x1, 24(x2)
	sw   x10, 20(x2)
	sw   x12, 16(x2)
	sw   x13, 12(x2)
	sw   x14, 8(x2)
	bge  x12, x13, end_mergesort
	add  x14, x12, x13
	srli x14, x14, 1
	sw   x14, 8(x2)
	addi x13, x14, 0
	jal  x1, mergesort
	lw   x10, 20(x2)
	lw   x12, 16(x2)
	lw   x13, 12(x2)
	lw   x14, 8(x2)
	addi x12, x14, 1
	jal  x1, mergesort
	lw   x10, 20(x2)
	lw   x12, 16(x2)
	lw   x13, 12(x2)
	lw   x14, 8(x2)
	addi x11, x14, 0
	jal  x1, merge
	lw   x10, 20(x2)
end_mergesort:
	lw   x1, 24(x2)
	addi x2, x2, 28
	jalr x6, 0(x1)

merge:
	addi x2, x2, -48
	sw   x1, 44(x2)
	sw   x10, 40(x2)
	sw   x11, 36(x2)
	sw   x12, 32(x2)
	sw   x13, 28(x2)
	la   x14, temp
	addi x15, x12, 0
	addi x16, x11, 1
	addi x17, x12, 0
merge_loop:
	blt  x11, x15, right_side
	blt  x13, x16, left_side
	slli x18, x15, 2
	add  x19, x10, x18
	lw   x20, 0(x19)
	slli x21, x16, 2
	add  x22, x10, x21
	lw   x23, 0(x22)
	blt  x20, x23, take_left
	j	take_right
take_left:
	slli x24, x17, 2
	add  x25, x14, x24
	sw   x20, 0(x25)
	addi x15, x15, 1
	addi x17, x17, 1
	j	merge_loop
take_right:
	slli x24, x17, 2
	add  x25, x14, x24
	sw   x23, 0(x25)
	addi x16, x16, 1
	addi x17, x17, 1
	j	merge_loop
left_side:
	blt  x11, x15, copy_done
	slli x18, x15, 2
	add  x19, x10, x18
	lw   x20, 0(x19)
	slli x24, x17, 2
	add  x25, x14, x24
	sw   x20, 0(x25)
	addi x15, x15, 1
	addi x17, x17, 1
	j	left_side
right_side:
	blt  x13, x16, copy_done
	slli x21, x16, 2
	add  x22, x10, x21
	lw   x23, 0(x22)
	slli x24, x17, 2
	add  x25, x14, x24
	sw   x23, 0(x25)
	addi x16, x16, 1
	addi x17, x17, 1
	j	right_side
copy_done:
	addi x17, x12, 0
copyback_loop:
	blt  x13, x17, merge_exit
	slli x24, x17, 2
	add  x25, x14, x24
	lw   x26, 0(x25)
	add  x27, x10, x24
	sw   x26, 0(x27)
	addi x17, x17, 1
	j	copyback_loop
merge_exit:
	lw   x1, 44(x2)
	lw   x10, 40(x2)
	addi x2, x2, 48
	jalr x6, 0(x1)

major:
	la   x10, array
	lw   x11, n
	addi x12, x0, 0
	addi x13, x11, -1
	jal  x1, mergesort
	wfi



