.data
val: .word 5        # branch NOT taken

.text
la   x10, val
lw   x5, 0(x10)
beq  x5, x0, L1
addi x6, x0, 7
L1:
addi x6, x0, 3
wfi
