    .text
    .global main

main:
    # --- SETUP: Initialize registers to force branch TAKEN ---
    addi x10, x0, 10       # x10 = 10 (Used for comparison)
    addi x11, x0, 20       # x11 = 20 (Used for comparison)
    addi x1, x0, 0         # x1 = 0 (If I2, I3, I4 execute, x1 will be non-zero)

    # -------------------------------------------------------------------
    # TEST #6: Control Hazard Flush (Branch)
    # Hazard: I1 is a BNE instruction. Since x10 != x11, the branch is TAKEN.
    # The outcome is determined in MEM, but the next PC is predicted NOT TAKEN.
    #
    # Expected Action: Misprediction detected in MEM stage. HDU forces a
    # 3-cycle flush of instructions I2, I3, I4. 

    # I1: BRANCH INSTRUCTION (Producer of the new PC)
    # The branch is TAKEN because 10 != 20.
    bne x10, x11, BranchTarget # I1: Branch to BranchTarget (Resolves in MEM)

    # I2, I3, I4: INSTRUCTIONS TO BE FLUSHED
    # These instructions were fetched based on the "Predict Not Taken" assumption.
    # If the flush fails, these instructions will execute, and x1 will be non-zero.
    addi x1, x1, 10        # I2: FLUSHED. Should not execute.
    slli x1, x1, 2         # I3: FLUSHED. Should not execute.
    ori x1, x1, 1          # I4: FLUSHED. Should not execute.

    j FlushFailed          # Jumps to the failure section if execution reaches here (flush failed)

BranchTarget:
    # I5: VERIFICATION (Only executed instruction after the branch)
    # If flush worked, x1 will still be 0, and x12 will be 1.
    addi x12, x0, 1        # I5: x12 = 1.

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
