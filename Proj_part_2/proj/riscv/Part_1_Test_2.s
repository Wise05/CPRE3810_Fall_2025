# Test 2: MEM/WB → EX forwarding
addi x1, x0, 10
addi x2, x0, 20
add  x3, x1, x2
nop
add  x4, x3, x2      # value of x3 must be forwarded from WB stage
wfi
