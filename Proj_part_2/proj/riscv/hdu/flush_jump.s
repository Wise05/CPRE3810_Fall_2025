    .text
    .global main

main:
    # --- SETUP: Initialize registers for verification ---
    addi x10, x0, 10       # x10 = 10 (Used for verification later)
    addi x1, x0, 0         # x1 = 0 (If I2, I3, I4 execute, x1 will be non-zero)

    # -------------------------------------------------------------------
    # TEST #5: Control Hazard Flush (JAL)
    # Hazard: I1 is a JAL instruction. Target address is known in EX,
    # but the PC update happens after I1 finishes MEM.
    #
    # Expected Action: HDU detects I1 is JAL and kills the 3 instructions
    # immediately following it (I2, I3, I4) by converting them to NOPs/flush.
    # 

    # I1: JUMP INSTRUCTION (Producer of the new PC)
    # I1 executes and writes the return address (PC+4) to x11.
    jal x11, TargetLabel   # I1: Jump to TargetLabel (Resolves in MEM)

    # I2, I3, I4: INSTRUCTIONS TO BE FLUSHED
    # If the flush fails, these instructions will execute, and x1 will be 10.
    addi x1, x1, 10        # I2: FLUSHED. Should not execute.
    slli x1, x1, 2         # I3: FLUSHED. Should not execute.
    ori x1, x1, 1          # I4: FLUSHED. Should not execute.

TargetLabel:
    # I5: VERIFICATION (Only executed instruction after the JAL)
    # If flush worked, x1 will still be 0, and x12 will be 10.
    addi x12, x10, 0       # I5: x12 = 10.

    # -------------------------------------------------------------------
    # VERIFICATION CHECK
    # Check if x1 is still 0. If it is 10, the flush failed.
    bne x1, x0, FlushFailed # If x1 != 0, jump to FlushFailed (failure case)
    j End                   # Success case

FlushFailed:
    # A debugging marker for simulation
    addi x30, x0, 1         # Indicate that the flush failed (x30 = 1)

End:
    # PROGRAM TERMINATION
    wfi                    # Halt the processor.
