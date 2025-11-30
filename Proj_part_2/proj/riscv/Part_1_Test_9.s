auipc x3, 0
add   x4, x3, x3
beq   x4, x0, label
addi  x7, x0, 99     # should be flushed
label:
wfi
