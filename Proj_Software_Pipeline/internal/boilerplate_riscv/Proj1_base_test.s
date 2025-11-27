.data
var1:   .word 0x12345678
var2:   .word 0xABCDEF01
arr:    .word 1,2,3,4
bytearr:.byte 0x12, 0x34, 0x56, 0x78
halfarr:.half 0x1111, 0x2222

.text
main:
############################################################
# LUI / AUIPC
############################################################
    lui   x5, 0x74565          # load upper immediate
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    auipc x6, 0x10             # PC-relative immediate add
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
############################################################
# ADDI / ADD / SUB
############################################################
    addi  x7, x0, 5
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x8, x0, 10
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    add   x9, x7, x8
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    sub   x10, x8, x7
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
############################################################
# ANDI / AND / ORI / OR / XORI / XOR
############################################################
    andi  x11, x9, 0x0F
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    and   x12, x11, x9
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    ori   x13, x0, 0xF
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    or    x14, x13, x12
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    xori  x15, x14, 0xAA
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    xor   x16, x15, x14
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
############################################################
# SLT / SLTI / SLTIU
############################################################
    addi  x17, x0, -1
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    slt   x18, x7, x8
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    slti  x19, x7, 10
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    sltiu x20, x17, 0xFF
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
############################################################
# SLL / SLLI / SRL / SRLI / SRA / SRAI
############################################################
    sll   x21, x7, x8
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    slli  x22, x7, 2
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    srl   x23, x13, x7
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    srli  x24, x13, 4
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    sra   x25, x13, x7
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    srai  x26, x13, 4
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
############################################################
# LOADS: LW, LB, LH, LBU, LHU
############################################################
    # la x27, var1  -->  expanded
    lui   x27, %hi(var1)
    addi  x0, x0, 0          # NOP
    addi  x0, x0, 0          # NOP
    addi  x0, x0, 0          # NOP
    addi  x27, x27, %lo(var1)

    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    lw    x28, 0(x27)
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    lb    x29, 3(x27)
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    lh    x30, 0(x27)
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    lbu   x31, 1(x27)
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    lhu   x1, 2(x27)
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
############################################################
# STORE: SW
############################################################
    sw    x28, 0(x27)
############################################################
# BRANCHES: BEQ, BNE, BLT, BGE, BLTU, BGEU
############################################################
    addi  x2, x0, 5
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x3, x0, 5
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x4, x0, 10
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
beq_test:
    beq   x2, x3, equal_label
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x5, x0, 1
equal_label:
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    bne   x2, x4, notequal_label
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x6, x0, 2
notequal_label:
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    blt   x2, x4, less_label
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x7, x0, 3
less_label:
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    bge   x4, x2, greater_label
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x8, x0, 4
greater_label:
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    bltu  x2, x4, unsigned_less_label
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x9, x0, 5
unsigned_less_label:
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    bgeu  x4, x2, unsigned_ge_label
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x10, x0, 6
unsigned_ge_label:
############################################################
# JAL / JALR
############################################################
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    jal   x11, jump_label
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    jal   x0, end
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x12, x0, 9
jump_label:
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
    jalr  x0, 0(x11)
    addi  x0, x0, 0
    addi  x0, x0, 0
    addi  x0, x0, 0
end:
    wfi
############################################################
# End of test
############################################################

