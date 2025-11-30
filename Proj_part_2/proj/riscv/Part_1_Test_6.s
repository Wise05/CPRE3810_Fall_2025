# Test 6: JAL/Link Hazard
jal  x1, label       # x1 = PC+4
addi x2, x1, 5       # must forward x1 (link)
label:
wfi
