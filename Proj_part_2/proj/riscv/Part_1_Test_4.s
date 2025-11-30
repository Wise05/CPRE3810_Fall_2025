# Test 4: Load-Use Stall
li   x10, 0x10010000
lw   x5, 0(x10)
add  x6, x5, x1
wfi
