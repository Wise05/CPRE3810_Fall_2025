# Advanced JAL pipeline hazard test
# Tests longer dependency chains and multiple loads before JAL

.data
array: .word 10, 20, 30, 40
results: .word 0, 0, 0, 0

.text
main:
    lui x2, 0x10011       # Stack pointer
    lui x7, 0x10010       # Data base address
    
    # Test 1: Load-Load-Use-JAL (like inst #130-131-132-136)
    lw x8, 0(x7)          # Load value (10)
    lw x9, 0(x8)          # Load using x8 as address (dependent load!)
    add x10, x9, x8       # Use both loaded values
    addi x11, x10, 5      # Another dependency
    auipc x1, 0           # Get PC
    addi x1, x1, 12       # Adjust (dependency on x1)
    jal x0, target1            # JAL after long chain
    addi x11, x0, 999     # Should be skipped
target1:
    sw x11, 16(x7)        # Store result
    
    # Test 2: Exact pattern from inst #130-136
    lui x8, 0x10010       # Base address
    addi x8, x8, 4        # Point to array[1]
    lw x7, 0(x8)          # Load (inst #130 pattern)
    lw x7, 4(x7)          # Load using x7 (inst #131 pattern)
    add x30, x0, x7       # Move to x30 (inst #132)
    add x29, x0, x30      # Move to x29 (inst #133)
    auipc x1, 0           # Get PC (inst #134)
    addi x1, x1, 12       # Adjust (inst #135)
    jal x0, target2            # JAL (inst #136)
    addi x2, x0, 999      # Should be skipped (NOT inst #137!)
target2:
    addi x2, x2, -32      # This IS inst #137
    sw x29, 20(x8)        # Store to verify
    
    # Test 3: Stack operations with loads before JAL
    lui x2, 0x10011       # Reset stack
    addi x5, x0, 55
    sw x5, -4(x2)         # Store on stack
    lw x6, -4(x2)         # Load from stack
    addi x6, x6, 10       # Modify
    addi x2, x2, -32      # Adjust stack
    jal x0, target3            # JAL after stack ops
    addi x6, x0, 999      # Should be skipped
target3:
    sw x6, 24(x8)         # Should store 65
    
    # Exit
    addi x10, x0, 10
    wfi

