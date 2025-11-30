# Test 4: Load-Use Stall
li   x10, 0x10010000     # x10 = base address
li   x5, 0               # load immediate 0
sw   x5, 0(x10)          # store 0 into memory 
lw   x5, 0(x10)          # now load 0
add  x6, x5, x1
wfi
