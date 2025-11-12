#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#
# Adapted to RISC-V by Connor J. Link (3.1.2025)
# Per testing [3, 0, 2, 1] is the expected output (matches the original grendel.s in MARS)
.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d
adjacencymatrix:
        .word   6
        .word   0
        .word   0
        .word   3
visited:
	.byte 0 0 0 0
res_idx:
        .word   3
.text
        # NEW RISCV                # ORIGINAL MIPS
	li   sp, 0x10011000        # li $sp, 0x10011000
	addi x0, x0, 0             # NOP
	addi x0, x0, 0             # NOP
	li   fp, 0                 # li $fp, 0
	addi x0, x0, 0             # NOP
	addi x0, x0, 0             # NOP
	la   ra, pump              # la $ra pump
	addi x0, x0, 0             # NOP
	addi x0, x0, 0             # NOP
	j    main
pump:
        j end
	ebreak                     # halt
main:
        addi sp,    sp, -40        # addiu   $sp,$sp,-40
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   ra, 36(sp)            # sw      $31,36($sp)
        sw   fp, 32(sp)            # sw      $fp,32($sp)
        add  fp,    sp, x0         # add     $fp,$sp,$zero
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   x0, 24(sp)            # sw      $0,24($fp)
        j    main_loop_control
main_loop_body:
        lw   t4, 24(fp)            # lw      $4,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    trucks         # la      $ra, trucks
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    is_visited
trucks:
        xori t2,    t2, 1          # xori    $2,$2,0x1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        andi t2,    t2, 0xff       # andi    $2,$2,0x00ff
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        beq  t2,    x0, kick       # beq     $2,$0,kick
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t4, 24(fp)            # lw      $4,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
                                   # ; addi    $k0, $k0,1# breakpoint
        la   ra,    billowy        # la      $ra, billowy
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    topsort
billowy:
kick:
        lw   t2, 24(fp)            # lw      $2,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi t2,    t2, 1          # addiu   $2,$2,1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t2, 24(fp)            # sw      $2,24($fp)
main_loop_control:
        lw   t2, 24(fp)            # lw      $2,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        slti t2,    t2, 4          # slti    $2,$2, 4
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        beq  t2,    x0, hew        # beq     $2, $zero, hew # beq, j to simulate bne 
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    main_loop_body
hew:
        sw   x0, 28(fp)            # sw      $0,28($fp)
        j    welcome
wave:
        lw   t2, 28(fp)            # lw      $2,28($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi t2,    t2, 1          # addiu   $2,$2,1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t2, 28(fp)            # sw      $2,28($fp)
welcome:
        lw   t2, 28(fp)            # lw      $2,28($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        slti t2,    t2, 4          # slti    $2,$2,4
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        xori t2,    t2, 1          # xori    $2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        beq  t2,    x0, wave       # beq     $2,$0,wave
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   t2,    x0             # move    $2,$0
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   sp,    fp             # move    $sp,$fp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   ra, 36(sp)            # lw      $31,36($sp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   fp, 32(sp)            # lw      $fp,32($sp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi sp, sp, 40            # addiu   $sp,$sp,40
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        jr   ra                    # jr      $ra
        
interest:
        lw   t4, 24(fp)            # lw      $4,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    new            # la      $ra, new
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    is_visited
new:
        xori t2,    t2, 1          # xori    $2,$2,0x1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        andi t2,    t2, 0x0ff      # andi    $2,$2,0x00ff
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        beq  t2,    x0, tasteful   # beq     $2,$0,tasteful
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t4, 24(fp)            # lw      $4,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    partner        # la      $ra, partner
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    topsort
partner:
tasteful:
        addi t2,    fp, 28         # addiu   $2,$fp,28
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   t4,    t2             # move    $4,$2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    badge          # la      $ra, badge
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    next_edge
badge:
        sw   t2, 24(fp)            # sw      $2,24($fp)
        
turkey:
        lw   t3, 24(fp)            # lw      $3,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        li   t2, -1                # li      $2,-1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        beq  t3,    t2, telling    # beq     $3,$2,telling # beq, j to simulate bne
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    interest
telling:
        # NOTE: $v0 === $2
	la   t2,    res_idx        # la      $v0, res_idx
	addi x0, x0, 0             # NOP
	addi x0, x0, 0             # NOP
	lw   t2,  0(t2)            # lw      $v0, 0($v0)
	addi x0, x0, 0             # NOP
	addi x0, x0, 0             # NOP
        addi t4,    t2, -1         # addiu   $4,$2,-1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   t3,    res_idx        # la      $3, res_idx
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t4,  0(t3)            # sw      $4, 0($3)
        la   t4,    res            # la      $4, res
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
                                   # ; lui     $3,%hi(res_idx)
                                   # ; sw      $4,%lo(res_idx)($3)
                                   # ; lui     $4,%hi(res)
        slli t3,    t2, 2          # sll     $3,$2,2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        srli t3,    t3, 1          # srl     $3,$3,1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        srai t3,    t3, 1          # sra     $3,$3,1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        slli t3,    t3, 2          # sll     $3,$3,2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
       
       	xor  t6,    ra, t2         # xor     $at, $ra, $2 # does nothing 
       	addi x0, x0, 0             # NOP
       	addi x0, x0, 0             # NOP
        or   t6,    ra, t2         # nor     $at, $ra, $2 # does nothing 
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        neg  t6,    t6
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        
        la   t2,    res            # la      $2, res
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        li   a1,    0x0000ffff
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        and  t6,    t2, a1         # andi    $at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        add  t2,    t4, t6         # addu    $2, $4, $at
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        add  t2,    t3, t2         # addu    $2,$3,$2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t3, 48(fp)            # lw      $3,48($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t3,  0(t2)            # sw      $3,0($2)
        mv   sp,    fp             # move    $sp,$fp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   ra, 44(sp)            # lw      $31,44($sp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   fp, 40(sp)            # lw      $fp,40($sp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi sp,    sp, 48         # addiu   $sp,$sp,48
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        jr   ra                    # jr      $ra
   
topsort:
        addi sp,    sp, -48        # addiu   $sp,$sp,-48
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   ra, 44(sp)            # sw      $31,44($sp)
        sw   fp, 40(sp)            # sw      $fp,40($sp)
        mv   fp,    sp             # move    $fp,$sp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t4, 48(fp)            # sw      $4,48($fp)
        lw   t4, 48(fp)            # lw      $4,48($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    verse          # la      $ra, verse
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    mark_visited
verse:
        addi t2,    fp, 28         # addiu   $2,$fp,28
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t5, 48(fp)            # lw      $5,48($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   t4,    t2             # move    $4,$2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    joyous         # la      $ra, joyous
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    iterate_edges
joyous:
        addi t2,    fp, 28         # addiu   $2,$fp,28
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   t4,    t2             # move    $4,$2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    whispering     # la      $ra, whispering
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    next_edge
whispering:
        sw   t2, 24(fp)            # sw      $2,24($fp)
        j    turkey
iterate_edges:
        addi sp,    sp, -24        # addiu   $sp,$sp,-24
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   fp, 20(sp)            # sw      $fp,20($sp)
        mv   fp,    sp             # move    $fp,$sp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sub  t6,    fp, sp         # subu    $at, $fp, $sp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t4, 24(fp)            # sw      $4,24($fp)
        sw   t5, 28(fp)            # sw      $5,28($fp)
        lw   t2, 28(fp)            # lw      $2,28($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t2,  8(fp)            # sw      $2,8($fp)
        sw   x0, 12(fp)            # sw      $0,12($fp)
        lw   t2, 24(fp)            # lw      $2,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t4,  8(fp)            # lw      $4,8($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t3, 12(fp)            # lw      $3,12($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t4,  0(t2)            # sw      $4,0($2)
        sw   t3,  4(t2)            # sw      $3,4($2)
        lw   t2, 24(fp)            # lw      $2,24($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   sp,    fp             # move    $sp,$fp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   fp, 20(sp)            # lw      $fp,20($sp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi sp,    sp, 24         # addiu   $sp,$sp,24
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        jr   ra                    # jr      $ra
        
next_edge:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   ra, 28(sp)            # sw      $31,28($sp)
        sw   fp, 24(sp)            # sw      $fp,24($sp)
        add  fp,    x0, sp         # add     $fp,$zero,$sp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t4, 32(fp)            # sw      $4,32($fp)
        j    waggish
snail:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t3,  0(t2)            # lw      $3,0($2)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2, 32(fp)            # lw      $2,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2,  4(t2)            # lw      $2,4($2)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   t5,    t2             # move    $5,$2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        mv   t4,    t3             # move    $4,$3
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        la   ra,    induce         # la      $ra,induce
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    has_edge
induce:
        beq  t2,    x0, quarter    # beq     $2,$0,quarter
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2, 32(fp)            # lw      $2,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2,  4(t2)            # lw      $2,4($2)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi t4,    t2, 1          # addiu   $4,$2,1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t3, 32(fp)            # lw      $3,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t4,  4(t3)            # sw      $4,4($3)
        j    cynical
quarter:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2,  4(t2)            # lw      $2,4($2)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi t3,    t2, 1          # addiu   $3,$2,1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2, 32(fp)            # lw      $2,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t3,  4(t2)            # sw      $3,4($2)
waggish:
        lw   t2, 32(fp)            # lw      $2,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2,  4(t2)            # lw      $2,4($2)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        slti t2,    t2, 4          # slti    $2,$2,4
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        beq  t2,    x0, mark       # beq     $2,$zero,mark # beq, j to simulate bne 
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        j    snail
mark:
        li   t2, -1                # li      $2,-1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
cynical:
        mv   sp,    fp             # move    $sp,$fp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   ra, 28(sp)            # lw      $31,28($sp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   fp, 24(sp)            # lw      $fp,24($sp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        addi sp,    sp, 32         # addiu   $sp,$sp,32
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        jr   ra                    # jr      $ra
has_edge:
        addi sp,    sp, -32        # addiu   $sp,$sp,-32
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   fp, 28(sp)            # sw      $fp,28($sp)
        mv   fp,    sp             # move    $fp,$sp
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t4, 32(fp)            # sw      $4,32($fp)
        sw   t5, 36(fp)            # sw      $5,36($fp)
        la   t2,    adjacencymatrix# la      $2,adjacencymatrix
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t3, 32(fp)            # lw      $3,32($fp)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        slli t3,    t3, 2          # sll     $3,$3,2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        add  t2,    t3, t2         # addu    $2,$3,$2
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        lw   t2,  0(t2)            # lw      $2,0($2)
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t2, 16(fp)            # sw      $2,16($fp)
        li   t2,  1                # li      $2,1
        addi x0, x0, 0             # NOP
        addi x0, x0, 0             # NOP
        sw   t2,  8(fp)            # sw      $2,8($fp)
        sw   x0, 12(fp)            # sw      $0,12($fp)
        j    measley
look:
        lw   t2,  8(fp)            # lw
        nop
	nop
    	slli t2,	t2, 1      	# sll 	$2,$2,1
	nop
	nop
    	sw   t2,  8(fp)        	# sw  	$2,8($fp)
    	lw   t2, 12(fp)        	# lw  	$2,12($fp)
	nop
	nop
    	addi t2,	t2, 1      	# addiu   $2,$2,1
	nop
	nop
    	sw   t2, 12(fp)        	# sw  	$2,12($fp)
measley:
    	lw   t3, 12(fp)        	# lw  	$3,12($fp)
	nop
	nop
    	lw   t2, 36(fp)        	# lw  	$2,36($fp)
	nop
	nop
    	slt  t2,	t3, t2     	# slt 	$2,$3,$2
    	beq  t2,	x0, experience # beq 	$2,$0,experience # beq, j to simulate bne
	nop
	nop
    	j	look
	nop
	nop
experience:
    	lw   t3,  8(fp)        	# lw  	$3,8($fp)
	nop
	nop
    	lw   t2, 16(fp)        	# lw  	$2,16($fp)
	nop
	nop
    	and  t2,	t3, t2     	# and 	$2,$3,$2
	nop
	nop
    	slt  t2,	x0, t2     	# slt 	$2,$0,$2
	nop
	nop
    	andi t2,	t2, 0xff   	# andi	$2,$2,0x00ff
	nop
	nop
    	mv   sp,	fp         	# move	$sp,$fp
	nop
	nop
    	lw   fp, 28(sp)        	# lw  	$fp,28($sp)
	nop
	nop
    	addi sp,	sp, 32     	# addiu   $sp,$sp,32
    	jr   ra                	# jr  	$ra
	nop
	nop
   	 
mark_visited:
    	addi sp,	sp, -32    	# addiu   $sp,$sp,-32
    	sw   fp, 28(sp)        	# sw  	$fp,28($sp)
    	mv   fp,	sp         	# move	$fp,$sp
    	sw   t4, 32(fp)        	# sw  	$4,32($fp)
    	li   t2,  1            	# li  	$2,1
    	sw   t2,  8(fp)        	# sw  	$2,8($fp)
    	sw   x0, 12(fp)        	# sw  	$0,12($fp)
    	j	recast
	nop
	nop

example:
    	lw   t2,  8(fp)        	# lw  	$2,8($fp)
	nop
	nop
    	slli t2,	t2, 8      	# sll 	$2,$2,8
	nop
	nop
    	sw   t2,  8(fp)        	# sw  	$2,8($fp)
    	lw   t2, 12(fp)        	# lw  	$2,12($fp)
	nop
	nop
    	addi t2,	t2, 1      	# addiu   $2,$2,1
	nop
	nop
    	sw   t2, 12(fp)        	# sw  	$2,12($fp)
recast:
    	lw   t3, 12(fp)        	# lw  	$3,12($fp)
	nop
	nop
    	lw   t2, 32(fp)        	# lw  	$2,32($fp)
	nop
	nop
    	slt  t2,	t3, t2     	# slt 	$2,$3,$2
    	beq  t2,	x0, pat    	# beq 	$2,$zero,pat # beq, j to simulate bne
	nop
	nop
    	j	example
	nop
	nop
pat:

       	la   t2, visited         	# la  	$2, visited
    	sw   t2, 16(fp)          	# sw  	$2,16($fp)
    	lw   t2, 16(fp)          	# lw  	$2,16($fp)
	nop
	nop
    	lw   t3,  0(t2)          	# lw  	$3,0($2)
	nop
	nop
    	lw   t2,  8(fp)          	# lw  	$2,8($fp)
	nop
	nop
    	or   t3,	t3, t2       	# or  	$3,$3,$2
	nop
	nop
    	lw   t2, 16(fp)          	# lw  	$2,16($fp)
	nop
	nop
    	sw   t3,  0(t2)          	# sw  	$3,0($2)
    	mv   sp,	fp           	# move	$sp,$fp
	nop
	nop
    	lw   fp, 28(sp)          	# lw  	$fp,28($sp)
	nop
	nop
    	addi sp,	sp, 32       	# addiu   $sp,$sp,32
    	jr   ra                  	# jr  	$ra
	nop
	nop
   	 
is_visited:
    	addi sp,	sp, -32      	# addiu   $sp,$sp,-32
    	sw   fp, 28(sp)          	# sw  	$fp,28($sp)
    	mv   fp,	sp           	# move	$fp,$sp
    	sw   t4, 32(fp)          	# sw  	$4,32($fp)
    	ori  t2,	x0, 1        	# ori 	$2,$zero,1
    	sw   t2,  8(fp)          	# sw  	$2,8($fp)
    	sw   x0, 12(fp)          	# sw  	$0,12($fp)
    	j	evasive
	nop
	nop

justify:
    	lw   t2,  8(fp)          	# lw  	$2,8($fp)
	nop
	nop
    	slli t2,	t2, 8        	# sll 	$2,$2,8
	nop
	nop
    	sw   t2,  8(fp)          	# sw  	$2,8($fp)
    	lw   t2, 12(fp)          	# lw  	$2,12($fp)
	nop
	nop
    	addi t2,	t2, 1        	# addiu   $2,$2,1
	nop
	nop
    	sw   t2, 12(fp)          	# sw  	$2,12($fp)
evasive:
    	lw   t3, 12(fp)          	# lw  	$3,12($fp)
	nop
	nop
    	lw   t2, 32(fp)          	# lw  	$2,32($fp)
	nop
	nop
    	slt  t2,	t3, t2       	# slt 	$2,$3,$2
    	beq  t2,	x0,representative# beq $2,$0,representitive # beq, j to simulate bne
	nop
	nop
    	j	justify
	nop
	nop
representative:

    	la   t2,	visited      	# la  	$2,visited
	nop
	nop
    	lw   t2,  0(t2)          	# lw  	$2,0($2)
	nop
	nop
    	sw   t2, 16(fp)          	# sw  	$2,16($fp)
	nop
	nop
    	lw   t3, 16(fp)          	# lw  	$3,16($fp)
	nop
	nop
    	lw   t2,  8(fp)          	# lw  	$2,8($fp)
	nop
	nop
    	and  t2,	t3, t2       	# and 	$2,$3,$2
	nop
	nop
    	slt  t2,	x0, t2       	# slt 	$2,$0,$2
	nop
	nop
    	andi t2,	t2, 0xff     	# andi	$2,$2,0x00ff
	nop
	nop
    	mv   sp,	fp           	# move	$sp,$fp
	nop
	nop
    	lw   fp, 28(sp)          	# lw  	$fp,28($sp)
	nop
	nop
    	addi sp,	sp, 32       	# addiu   $sp,$sp,32
    	jr   ra                  	# jr  	$ra
	nop
	nop

end:
    	wfi
