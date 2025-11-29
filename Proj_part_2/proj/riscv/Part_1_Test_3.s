# Test 3: Store-Data Forwarding
addi x1, x0, 99
li   x2, 0x10010000
sw   x1, 0(x2)
wfi
