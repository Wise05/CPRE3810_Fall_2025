.data
var1:   .word 0x12345678
var2:   .word 0xABCDEF01
arr:    .word 1,2,3,4
bytearr:.byte 0x12, 0x34, 0x56, 0x78
halfarr:.half 0x1111, 0x2222
<<<<<<< HEAD
.text
main:
=======

.text

main:

>>>>>>> f00cf90 (I need a hero)
############################################################
# LUI / AUIPC
############################################################
    lui   x5, 0x74565          # load upper immediate
<<<<<<< HEAD
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    auipc x6, 0x10             # PC-relative immediate add
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
=======
    auipc x6, 0x10             # PC-relative immediate add

>>>>>>> f00cf90 (I need a hero)
############################################################
# ADDI / ADD / SUB
############################################################
    addi  x7, x0, 5            # x7 = 5
<<<<<<< HEAD
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x8, x0, 10           # x8 = 10
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    add   x9, x7, x8           # x9 = 15
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    sub   x10, x8, x7          # x10 = 5
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
=======
    addi  x8, x0, 10           # x8 = 10
    add   x9, x7, x8           # x9 = 15
    sub   x10, x8, x7          # x10 = 5

>>>>>>> f00cf90 (I need a hero)
############################################################
# ANDI / AND / ORI / OR / XORI / XOR
############################################################
    andi  x11, x9, 0x0F        # x11 = 15 & 15
<<<<<<< HEAD
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    and   x12, x11, x9         # x12 = 15
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    ori   x13, x0, 0xF         # x13 = 0xF
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    or    x14, x13, x12        # OR operation
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    xori  x15, x14, 0xAA       # XORI immediate
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    xor   x16, x15, x14        # XOR reg
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
=======
    and   x12, x11, x9         # x12 = 15

    ori   x13, x0, 0xF       # x13 = 0xF0F
    or    x14, x13, x12        # OR operation
    xori  x15, x14, 0xAA     # XORI immediate

    xor   x16, x15, x14        # XOR reg

>>>>>>> f00cf90 (I need a hero)
############################################################
# SLT / SLTI / SLTIU
############################################################
    addi  x17, x0, -1
<<<<<<< HEAD
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    slt   x18, x7, x8          # x18 = 1 (since 5 < 10)
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    slti  x19, x7, 10          # x19 = 1
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    sltiu x20, x17, 0xFF       # unsigned compare
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
=======
    slt   x18, x7, x8          # x18 = 1 (since 5 < 10)
    slti  x19, x7, 10          # x19 = 1
    sltiu x20, x17, 0xFF     # unsigned compare

>>>>>>> f00cf90 (I need a hero)
############################################################
# SLL / SLLI / SRL / SRLI / SRA / SRAI
############################################################
    sll   x21, x7, x8          # shift left by 10 (just to test)
<<<<<<< HEAD
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    slli  x22, x7, 2           # shift left immediate by 2
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    srl   x23, x13, x7         # shift right logical
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    srli  x24, x13, 4          # shift right logical imm
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    sra   x25, x13, x7         # shift right arithmetic
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    srai  x26, x13, 4          # shift right arithmetic imm
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
=======
    slli  x22, x7, 2           # shift left immediate by 2
    srl   x23, x13, x7         # shift right logical
    srli  x24, x13, 4          # shift right logical imm
    sra   x25, x13, x7         # shift right arithmetic
    srai  x26, x13, 4          # shift right arithmetic imm

>>>>>>> f00cf90 (I need a hero)
############################################################
# LOADS: LW, LB, LH, LBU, LHU
############################################################
    la    x27, var1
<<<<<<< HEAD
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    lw    x28, 0(x27)          # word load
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    lb    x29, 3(x27)          # load byte (sign-extended)
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    lh    x30, 0(x27)          # load half (sign-extended)
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    lbu   x31, 1(x27)          # load byte unsigned
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    lhu   x1, 2(x27)           # load half unsigned
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
=======
    lw    x28, 0(x27)          # word load
    lb    x29, 3(x27)          # load byte (sign-extended)
    lh    x30, 0(x27)          # load half (sign-extended)
    lbu   x31, 1(x27)          # load byte unsigned
    lhu   x1, 2(x27)           # load half unsigned

>>>>>>> f00cf90 (I need a hero)
############################################################
# STORE: SW
############################################################
    sw    x28, 0(x27)          # store word back to memory
<<<<<<< HEAD
=======

>>>>>>> f00cf90 (I need a hero)
############################################################
# BRANCHES: BEQ, BNE, BLT, BGE, BLTU, BGEU
############################################################
    addi  x2, x0, 5
<<<<<<< HEAD
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x3, x0, 5
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x4, x0, 10
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
beq_test:
    beq   x2, x3, equal_label  # should branch
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x5, x0, 1            # skipped
equal_label:
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    bne   x2, x4, notequal_label # should branch
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x6, x0, 2            # skipped
notequal_label:
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    blt   x2, x4, less_label   # should branch
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x7, x0, 3
less_label:
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    bge   x4, x2, greater_label # should branch
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x8, x0, 4
greater_label:
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    bltu  x2, x4, unsigned_less_label # should branch
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x9, x0, 5
unsigned_less_label:
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    bgeu  x4, x2, unsigned_ge_label # should branch
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    addi  x10, x0, 6
unsigned_ge_label:
############################################################
# JAL / JALR
############################################################
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    jal   x11, jump_label      # jump and link
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    jal   x0, end
    addi  x12, x0, 9           # skipped
jump_label:
    addi  x0, x0, 0            # NOP
    addi  x0, x0, 0            # NOP
    jalr  x0, 0(x11)           # return to next instruction
end:
    wfi
=======
    addi  x3, x0, 5
    addi  x4, x0, 10

beq_test:
    beq   x2, x3, equal_label   # should branch
    addi  x5, x0, 1             # skipped
equal_label:

    bne   x2, x4, notequal_label # should branch
    addi  x6, x0, 2              # skipped
notequal_label:

    blt   x2, x4, less_label     # should branch
    addi  x7, x0, 3
less_label:

    bge   x4, x2, greater_label  # should branch
    addi  x8, x0, 4
greater_label:

    bltu  x2, x4, unsigned_less_label  # should branch
    addi  x9, x0, 5
unsigned_less_label:

    bgeu  x4, x2, unsigned_ge_label    # should branch
    addi  x10, x0, 6
unsigned_ge_label:

############################################################
# JAL / JALR
############################################################
    jal   x11, jump_label       # jump and link
    jal   x0, end
    addi  x12, x0, 9            # skipped
jump_label:
    jalr  x0, 0(x11)            # return to next instruction

end:
    wfi

>>>>>>> f00cf90 (I need a hero)
############################################################
# End of test
############################################################
