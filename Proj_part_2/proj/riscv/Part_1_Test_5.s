# Test 5: Branch Taken → Flush
addi x1, x0, 1
addi x2, x0, 1
beq  x1, x2, target   # taken → flush next inst
addi x3, x0, 9        # must be flushed
target:
addi x3, x0, 5
wfi
