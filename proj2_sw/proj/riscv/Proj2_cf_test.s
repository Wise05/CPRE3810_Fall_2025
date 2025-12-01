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
    la      ra, main_ret       # set return address
    j       func1              # call first function

############################################################
# FUNC1
############################################################
func1:
    addi    x2, x2, -16        # push frame
    sw      ra, 12(x2)         # save return addr
    sw      x10, 8(x2)         # save depth counter
    
    addi    x11, x10, 3
    xor     x12, x11, x10
    andi    x13, x12, 0xFF
    slti    x14, x13, 100
    bne     x14, x0, func1_call # if x14 != 0, make call
    j       func1_skip
    
func1_call:
    addi    x10, x10, -1       # decrement depth
    addi    x6, x0, 1          # x6 = 1 for comparison
    blt     x10, x6, func1_skip # if depth < 1, skip call
    la      ra, func1_ret      # set return address
    j       func2              # call next function
func1_ret:
    
func1_skip:
    lw      x10, 8(x2)         # restore depth counter
    lw      ra, 12(x2)         # restore return addr
    addi    x2, x2, 16         # pop frame
    jr      ra                 # return

############################################################
# FUNC2
############################################################
func2:
    addi    x2, x2, -16
    sw      ra, 12(x2)
    sw      x10, 8(x2)         # save depth counter
    
    lui     x15, 0x20000
    auipc   x16, 0x10
    sub     x17, x16, x15
    ori     x18, x17, 0x123
    slt     x19, x10, x11
    sltiu   x20, x19, 10
    
    addi    x10, x10, -1       # decrement depth
    addi    x6, x0, 1          # x6 = 1 for comparison
    blt     x10, x6, func2_skip # if depth < 1, skip call
    la      ra, func2_ret      # set return address
    j       func3
func2_ret:
    
func2_skip:
    lw      x10, 8(x2)         # restore depth counter
    lw      ra, 12(x2)
    addi    x2, x2, 16
    jr      ra                 # return

############################################################
# FUNC3
############################################################
func3:
    addi    x2, x2, -32
    sw      ra, 28(x2)
    sw      x10, 24(x2)        # save depth counter
    
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
    sra     x7, x22, x29
    sw      x22, 0(x21)        # store word
    
    addi    x10, x10, -1       # decrement depth
    addi    x6, x0, 1          # x6 = 1 for comparison
    blt     x10, x6, func3_skip # if depth < 1, skip call
    la      ra, func3_ret      # set return address
    j       func4
func3_ret:
    
func3_skip:
    lw      x10, 24(x2)        # restore depth counter
    lw      ra, 28(x2)
    addi    x2, x2, 32
    jr      ra                 # return

############################################################
# FUNC4
############################################################
func4:
    addi    x2, x2, -16
    sw      ra, 12(x2)
    sw      x10, 8(x2)         # save depth counter
    
    addi    x3, x0, 5
    addi    x4, x0, 5
    addi    x5, x0, 10
    bne     x3, x4, func4_ne1
    j       func4_eq1
func4_ne1:
    addi    x7, x0, 99
func4_eq1:
    beq     x3, x5, func4_eq2
    j       func4_ne2
func4_eq2:
    addi    x7, x0, 98
func4_ne2:
    bge     x3, x5, func4_ge1
    j       func4_lt1
func4_ge1:
    addi    x8, x0, 97
func4_lt1:
    blt     x5, x3, func4_lt2
    j       func4_ge2
func4_lt2:
    addi    x9, x0, 96
func4_ge2:
    bgeu    x3, x5, func4_geu
    j       func4_ltu
func4_geu:
    addi    x28, x0, 95
func4_ltu:
    bltu    x5, x3, func4_ltuc
    j       func4_geuc
func4_ltuc:
    addi    x29, x0, 94
func4_geuc:
    addi    x10, x10, -1       # decrement depth
    addi    x6, x0, 1          # x6 = 1 for comparison
    blt     x10, x6, func4_skip # if depth < 1, skip call
    la      ra, func4_ret      # set return address
    j       func5
func4_ret:
    
func4_skip:
    lw      x10, 8(x2)         # restore depth counter
    lw      ra, 12(x2)
    addi    x2, x2, 16
    jr      ra                 # return

############################################################
# FUNC5
############################################################
func5:
    addi    x2, x2, -16
    sw      ra, 12(x2)
    sw      x10, 8(x2)         # save depth counter
    
    addi    x11, x0, 1
    addi    x12, x0, 2
    addi    x13, x0, 3
    add     x14, x11, x12
    sub     x15, x13, x11
    or      x16, x14, x15
    and     x17, x14, x15
    xor     x18, x14, x16
    
    addi    x10, x10, -1       # decrement depth
    addi    x6, x0, 1          # x6 = 1 for comparison
    blt     x10, x6, func5_skip # if depth < 1, skip call
    la      ra, func5_ret      # set return address
    j       func6
func5_ret:
    
func5_skip:
    lw      x10, 8(x2)         # restore depth counter
    lw      ra, 12(x2)
    addi    x2, x2, 16
    jr      ra                 # return

############################################################
# FUNC6 — deepest level, can recurse back to func1
############################################################
func6:
    addi    x2, x2, -16
    sw      ra, 12(x2)
    sw      x10, 8(x2)         # save depth counter
    
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
    
    addi    x10, x10, -1       # decrement depth
    addi    x6, x0, 1          # x6 = 1 for comparison
    blt     x10, x6, func6_skip # if depth < 1, skip call
    la      ra, func6_ret      # set return address
    j       func1              # recurse back to func1 to restart chain
func6_ret:
    
func6_skip:
    lw      x10, 8(x2)         # restore depth counter
    lw      ra, 12(x2)
    addi    x2, x2, 16
    jr      ra                 # return
main_ret:
    wfi                        # end of program

