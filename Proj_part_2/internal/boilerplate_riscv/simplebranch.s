main:
	ori s0, x0, 0x123
	j skip
	li s0, 0xffffffff     # This instruction should never execute
skip:
	ori s1, x0, 0x123
	beq s0, s1, skip2
	li s0, 0xffffffff     # This instruction should not execute if branch taken
skip2:
	jal fun
	ori s3, x0, 0x1
	beq s0, x0, exit
	ori s4, x0, 0x2
	j exit
fun:
	ori s2, x0, 0x3
	jr ra
exit:
	wfi
