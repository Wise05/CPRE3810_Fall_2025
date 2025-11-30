addi x1, x0, 22
sw   x1, 0(x2)      # store-data forwarding
lw   x3, 0(x2)
add  x4, x3, x1     # load-use stall + forwarding
wfi
