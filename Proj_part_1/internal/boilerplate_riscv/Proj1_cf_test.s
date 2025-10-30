.data
valA:   .word 0x12345678
valB:   .word 0xABCDEF01
arr:    .word 10, 20, 30, 40
bytes:  .byte 0x11, 0x22, 0x33, 0x44
halfs:  .half 0x5555, 0xAAAA

.text
.globl main

############################################################
# MAIN — sets up stack and starts the deep call chain
############################################################
main:
    lui     x2, 0x10010        # set up stack base (upper 20 bits)
    addi    x2, x2, -4         # stack pointer
    addi    x10, x0, 5         # argument: depth count
    jal     x1, func1          # call first function
    wfi                        # end of program

############################################################
# FUNC1
############################################################
func1:
    addi    x2, x2, -16        # push frame
    sw      x1, 12(x2)         # save return addr
    addi    x11, x10, 3
    xor     x12, x11, x10
    andi    x13, x12, 0xFF
    slti    x14, x13, 100
    beq     x14, x0, skip1
    jal     x1, func2          # call next function
skip1:
    lw      x1, 12(x2)
    addi    x2, x2, 16         # pop frame
    jalr    x6, 0(x1)          # return (use x6 instead of x0)

############################################################
# FUNC2
############################################################
func2:
    addi    x2, x2, -16
    sw      x1, 12(x2)
    lui     x15, 0x20000
    auipc   x16, 0x10
    sub     x17, x16, x15
    ori     x18, x17, 0x123
    slt     x19, x10, x11
    sltiu   x20, x19, 10
    jal     x1, func3
    lw      x1, 12(x2)
    addi    x2, x2, 16
    jalr    x6, 0(x1)          # return (use x6 instead of x0)

############################################################
# FUNC3
############################################################
func3:
    addi    x2, x2, -32
    sw      x1, 28(x2)
    la      x21, valA
    lw      x22, 0(x21)
    lb      x23, 0(x21)
    lh      x24, 0(x21)
    lbu     x25, 1(x21)
    lhu     x26, 2(x21)
    slli    x27, x23, 1
    srli    x28, x23, 1
    srai    x29, x22, 2
    sll     x30, x23, x27
    srl     x31, x23, x28
    sra     x7, x22, x29       # use x7 instead of x1 to avoid clobbering return addr
    sw      x22, 0(x21)        # store word
    jal     x1, func4
    lw      x1, 28(x2)
    addi    x2, x2, 32
    jalr    x6, 0(x1)          # return (use x6 instead of x0)

############################################################
# FUNC4
############################################################
func4:
    addi    x2, x2, -16
    sw      x1, 12(x2)
    addi    x3, x0, 5
    addi    x4, x0, 5
    addi    x5, x0, 10
    beq     x3, x4, equal_4
    addi    x7, x0, 99         # changed from x6 to x7
equal_4:
    bne     x3, x5, notequal_4
    addi    x7, x0, 98         # changed from x6 to x7
notequal_4:
    blt     x3, x5, less_4
    addi    x8, x0, 97         # changed from x7 to x8
less_4:
    bge     x5, x3, greater_4
    addi    x9, x0, 96         # changed from x8 to x9
greater_4:
    bltu    x3, x5, uless_4
    addi    x28, x0, 95        # changed from x9 to x28
uless_4:
    bgeu    x5, x3, uge_4
    addi    x29, x0, 94        # changed from x10 to x29
uge_4:
    jal     x1, func5
    lw      x1, 12(x2)
    addi    x2, x2, 16
    jalr    x6, 0(x1)          # return (use x6 instead of x0)

############################################################
# FUNC5
############################################################
func5:
    addi    x2, x2, -16
    sw      x1, 12(x2)
    addi    x11, x0, 1
    addi    x12, x0, 2
    addi    x13, x0, 3
    add     x14, x11, x12
    sub     x15, x13, x11
    or      x16, x14, x15
    and     x17, x14, x15
    xor     x18, x14, x16
    jal     x1, func6
    lw      x1, 12(x2)
    addi    x2, x2, 16
    jalr    x6, 0(x1)          # return (use x6 instead of x0)

############################################################
# FUNC6 — deepest level (5th level)
############################################################
func6:
    addi    x2, x2, -16
    sw      x1, 12(x2)
    # Do some ALU and memory operations
    la      x19, arr
    lw      x20, 0(x19)
    addi    x21, x20, 5
    sw      x21, 4(x19)
    la      x22, bytes
    lb      x23, 0(x22)
    lbu     x24, 1(x22)
    lh      x25, 0(x22)
    lhu     x26, 2(x22)
    # Bit shifts again for thoroughness
    slli    x27, x23, 2
    srli    x28, x23, 1
    srai    x29, x25, 1
    # Return up the chain
    lw      x1, 12(x2)
    addi    x2, x2, 16
    jalr    x6, 0(x1)          # return (use x6 instead of x0)
