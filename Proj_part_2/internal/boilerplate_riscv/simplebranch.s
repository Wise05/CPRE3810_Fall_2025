main:
	ori s0, x0, 0x123
	addi x0, x0, 0        # NOP
	addi x0, x0, 0        # NOP
	j skip
	addi x0, x0, 0
	addi x0, x0, 0  
	addi x0, x0, 0
	li s0, 0xffffffff     # This instruction should never execute
skip:
	ori s1, x0, 0x123
	addi x0, x0, 0        # NOP
	addi x0, x0, 0        # NOP
        addi x0, x0, 0
	beq s0, s1, skip2
	addi x0, x0, 0        # NOP (branch delay)
	addi x0, x0, 0        # NOP (branch delay)
        addi x0, x0, 0
	li s0, 0xffffffff     # This instruction should not execute if branch taken
skip2:
	addi x0, x0, 0        # NOP
	addi x0, x0, 0        # NOP
	jal fun
	addi x0, x0, 0        # NOP (after jal, before return address used)
	addi x0, x0, 0        # NOP
	addi x0, x0, 0
	ori s3, x0, 0x123
	addi x0, x0, 0        # NOP
	addi x0, x0, 0        # NOP
	beq s0, x0, exit
	addi x0, x0, 0        # NOP (branch delay)
	addi x0, x0, 0        # NOP (branch delay)
	addi x0, x0, 0
	ori s4, x0, 0x123
	addi x0, x0, 0        # NOP
	addi x0, x0, 0        # NOP
	j exit
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
fun:
	ori s2, x0, 0x123
	addi x0, x0, 0        # NOP
	addi x0, x0, 0        # NOP
	jr ra
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
exit:
	wfi
