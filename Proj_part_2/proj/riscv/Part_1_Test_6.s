# Test 7: JALR Hazard
addi x1, x0, 0
la   x1, target       # load actual label address into x1

jalr x0, x1, 0
addi x2, x0, 9        # MUST be flushed

target:
addi x3, x0, 5
wfi
