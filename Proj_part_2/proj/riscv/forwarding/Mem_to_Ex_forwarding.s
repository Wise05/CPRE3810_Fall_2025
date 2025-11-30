    .text
    .global main

main:
    # --- 1. SETUP (Initialize registers for dependencies) --------------------
    # Set x2 = 20 (for use later) and x10 = 5
    addi x2, x0, 20
    addi x10, x0, 5        # I1: x10 = 5 (Producer)


    # --- 2. ALU/PC-to-EX (1-Cycle Forwarding) - Test #1 ---------------------
    # Hazard: I3 needs x1, which I2 produces 1 cycle earlier (available EX/MEM)
    slti x1, x10, 10       # I2: x1 = 1 (Result ready at end of I2's EX stage)
    or x3, x1, x2          # I3: CONSUMER. Reads x1 (Rs1).
                           # ACTION: Forward x1 value from EX/MEM to I3's EX input.
                           # No stall required.


    # --- 3. Load-Use Data Stall (HDU) - Test #4 -----------------------------
    # Hazard: I5 is a load, I6 uses the result immediately.
    # Note: We must load from a safe address, here using stack pointer offset
    # for simulation safety, assuming sp (x2) points to writable memory.
    addi sp, sp, -4        # Adjust stack pointer
    sw x10, 0(sp)          # Store x10 (5) to memory
    lui x4, 0x10000        # I4: x4 = 0x10000000 (Dummy address setup for load base)
    lw x5, 0(sp)           # I5: PRODUCER. x5 = Mem[sp] (Load result available WB)
                           # **NOTE: For real testing, ensure 0(sp) is readable.**
    addi x6, x5, 1         # I6: CONSUMER. Reads x5 (Rs1) IMMEDIATELY.
                           # ACTION: HDU detects hazard (I5.Rd == I6.Rs1) and inserts 1 NOP stall.
                           # I6 stalls in ID, I5 continues to MEM.


    # --- 4. 2-Cycle Forwarding (Load & ALU) - Test #2 & #3 ------------------
    # Hazard: I9 reads results from I6 (Load, 2 cycles ago) and I8 (ALU, 2 cycles ago).
    # The two instructions (I7, I8) between I6 and I9 serve as spacers.
    addi x7, x0, 2         # I7: PRODUCER A (ALU). x7 = 2
    sub x8, x7, 1          # I8: PRODUCER B (ALU). x8 = 1
    and x9, x6, x8         # I9: CONSUMER. Reads x6 (Load result from I6) and x8 (ALU result from I8).
                           # ACTION (x6): Forward I6's value from MEM/WB to I9's EX input. (Test #2)
                           # ACTION (x8): Forward I8's value from MEM/WB to I9's EX input. (Test #3)


    # --- 5. Control Hazard Flush (JAL) - Test #5 ----------------------------
    # Hazard: JAL resolves in MEM, requiring a 3-cycle flush of the pipeline.
    jal x11, Target        # I10: JUMP. Calculates target in EX, resolves in MEM.
    addi x1, x1, 100       # I11: FLUSHED. This instruction is killed in ID/EX.
    slli x1, x1, 2         # I12: FLUSHED. This instruction is killed in IF/ID.

Target:
    # --- 6. Control Hazard Flush (Branch) - Test #6 -------------------------
    # Hazard: Branch resolves in MEM, requiring a 3-cycle flush of the pipeline on misprediction.
    # Instruction x0, x0 are equal, so the branch is NOT taken (falls through).
    bne x0, x0, BranchFail # I13: BRANCH. Branch NOT taken.
    # If the pipeline predicts TAKEN (misprediction), I14 and I15 are fetched.
    or x1, x2, x3          # I14: FLUSHED. Mispredicted instruction.
    srai x1, x1, 1         # I15: FLUSHED. Mispredicted instruction.
    j End                  # Ensure we skip the target label if branch is not taken

BranchFail:
    # This label is not reached in this specific test case (branch not taken)
    addi x30, x0, 1 # Dummy instruction

End:
    # Cleanup stack pointer (best practice)
    addi sp, sp, 4

    # --- 7. END OF PROGRAM --------------------------------------------------
    wfi                    # I16: Halt the processor.
