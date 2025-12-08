.data
fibs: .word 0 : 19         # array to contain fib values
size: .word 19             # size of array (agrees with declaration)

.text
###############################################################
# ---- Setup ----
# la s0, fibs
    lui   s0, %hi(fibs)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  s0, s0, %lo(fibs)

# la s5, size
    lui   s5, %hi(size)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  s5, s5, %lo(size)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

    lw    s5, 0(s5)        # load array size

# Initialize Fibonacci base cases
    li    s2, 1            # F[0] = F[1] = 1
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    sw    s2, 0(s0)
    sw    s2, 4(s0)

# Prepare loop counter: s1 = s5 - 2
    addi  s1, s5, -2

###############################################################
# ---- Fibonacci loop ----
loop:
    lw    s3, 0(s0)        # s3 = F[n-2]
    lw    s4, 4(s0)        # s4 = F[n-1]
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

    add   s2, s3, s4       # s2 = F[n]
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

    sw    s2, 8(s0)        # F[n] stored
    addi  s0, s0, 4        # advance pointer

    addi  s1, s1, -1       # decrement counter
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

    bne   s1, zero, loop   # continue if not done
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

###############################################################
# ---- Printing phase ----
# la a0, fibs
    lui   a0, %hi(fibs)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  a0, a0, %lo(fibs)

    add   a1, zero, s5
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

    jal   print
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    j     die
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

###############################################################
# ---- Subroutine: print ----
.data
space: .asciz " "
head:  .asciz "The Fibonacci numbers are:\n"
.text

print:
    add   t0, zero, a0
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    add   t1, zero, a1
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP

# la a0, head
    lui   a0, %hi(head)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  a0, a0, %lo(head)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    ori   a7, zero, 4
    ecall                  # print heading

out:
    lw    a0, 0(t0)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    ori   a7, zero, 1
    ecall                  # print number

# la a0, space
    lui   a0, %hi(space)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  a0, a0, %lo(space)
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    ori   a7, zero, 4
    ecall                  # print space

    addi  t0, t0, 4
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  t1, t1, -1
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    bne   t1, zero, out
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    jr    ra
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    addi  x0, x0, 0        # NOP
    
    

###############################################################
die:
    wfi

