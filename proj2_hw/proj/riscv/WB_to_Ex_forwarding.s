.text
    .global main
main:
    # --- SETUP: Initialize Base Register and Memory ---
    addi x10, x0, 5        # x10 = 5 (Data to be stored/loaded)
    addi x11, x0, 10       # x11 = 10 (Data for the ALU operation)
    lui x12, 0x10000       # x12 = 0x10000000 (Base address for memory)
    sw x10, 0(x12)         # Store 5 at 0x10000000
    
    # -------------------------------------------------------------------
    # TEST #2: Load-to-EX Forwarding (2-Cycle Separation)
    # The Load result (x1) must be forwarded from the WB stage (MEM/WB register).
    #
    # Timeline:
    # LW (I1): MEM stage
    # ADDI (I2): EX stage (Spacer)
    # ANDI (I3): ID stage (Spacer)
    # ADD (I4): ID stage (Reads x1)
    #
    # When I4 is in EX, I1 is in WB (MEM/WB register).
    # I1: PRODUCER (Load)
    lw x1, 0(x12)          # I1: x1 = 5 (Result ready at end of MEM stage, written in WB)
    # I2 & I3: SPACERS (2 cycles of separation)
    addi x2, x0, 1         # I2: Spacer 1
    andi x3, x0, 0         # I3: Spacer 2
    # I4: CONSUMER (Uses the load result x1)
    add x4, x1, x2         # I4: CONSUMER. Reads x1 (Rs1)
                           # ACTION: Forward x1 value from MEM/WB to I4's EX input.
                           # Expected: x4 = 5 + 1 = 6
    
    # -------------------------------------------------------------------
    # TEST #3: ALU-to-EX Forwarding (2-Cycle Separation)
    # The ALU result (x5) must be forwarded from the WB stage (MEM/WB register).
    #
    # Timeline:
    # LUI (I5): MEM stage
    # ORI (I6): EX stage (Spacer)
    # ADDI (I7): ID stage (Spacer - FIXED: removed JALR)
    # SLT (I8): ID stage (Reads x5)
    #
    # When I8 is in EX, I5 is in WB (MEM/WB register).
    # I5: PRODUCER (ALU/PC-Type)
    lui x5, 0x10000        # I5: x5 = 0x10000000 (Result ready at end of EX stage, written in WB)
    # I6 & I7: SPACERS (2 cycles of separation)
    ori x6, x0, 7          # I6: Spacer 1
    addi x13, x0, 3        # I7: Spacer 2 (Changed from JALR to avoid control flow disruption)
    # I8: CONSUMER (Uses the ALU result x5)
    slt x7, x5, x11        # I8: CONSUMER. Reads x5 (Rs1).
                           # ACTION: Forward x5 value from MEM/WB to I8's EX input.
                           # Expected: x5 > x11 (large number vs 10), so x7 = 0.
    
    # -------------------------------------------------------------------
    # PROGRAM TERMINATION
    wfi                    # Halt the processor.
