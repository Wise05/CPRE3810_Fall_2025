# Test 1: EX/MEM → EX Forwarding
addi x1, x0, 5
addi x2, x0, 7
add  x3, x1, x2      # x3 = 12
add  x4, x3, x1      # should forward x3 from EX/MEM
wfi
