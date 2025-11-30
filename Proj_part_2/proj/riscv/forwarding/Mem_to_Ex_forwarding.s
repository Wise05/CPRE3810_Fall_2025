.text
    .global main
main:
    # --- 1. SETUP (Initialize registers for dependencies) --------------------
    addi x2, x0, 20
    addi x10, x0, 5        # I1: x10 = 5 (Producer)
    
    # --- 2. ALU/PC-to-EX (1-Cycle Forwarding) - Test #1 ---------------------
    slti x1, x10, 10       # I2: x1 = 1 (Result ready at end of I2's EX stage)
    or x3, x1, x2          # I3: CONSUMER. Reads x1 (Rs1).
                           # ACTION: Forward x1 value from EX/MEM to I3's EX input.
    
    # --- 3. Load-Use Data Stall (HDU) - Test #4 -----------------------------
    # Use a fixed memory address instead of stack pointer
    lui x4, 0x10000        # I4: x4 = 0x10000000 (Base address)
    sw x10, 0(x4)          # Store x10 (5) to memory at 0x10000000
    lw x5, 0(x4)           # I5: PRODUCER. x5 = Mem[0x10000000] (Load result available WB)
    addi x6, x5, 1         # I6: CONSUMER. Reads x5 (Rs1) IMMEDIATELY.
                           # ACTION: HDU detects hazard and inserts 1 NOP stall.
    
    # --- 4. 2-Cycle Forwarding (Load & ALU) - Test #2 & #3 ------------------
    addi x7, x0, 2         # I7: PRODUCER A (ALU). x7 = 2
    addi x29, x0, 1
    sub x8, x7, x29        # I8: PRODUCER B (ALU). x8 = 1
    and x9, x6, x8         # I9: CONSUMER. Reads x6 and x8.
                           # ACTION: Forward from MEM/WB to I9's EX input.
    
    # --- 5. Control Hazard Flush (JAL) - Test #5 ----------------------------
    jal x11, Target        # I10: JUMP. Calculates target in EX, resolves in MEM.
    addi x1, x1, 100       # I11: FLUSHED
    slli x1, x1, 2         # I12: FLUSHED
Target:
    # --- 6. Control Hazard Flush (Branch) - Test #6 -------------------------
    bne x0, x0, BranchFail # I13: BRANCH. Branch NOT taken.
    or x1, x2, x3          # I14: FLUSHED (if mispredicted)
    srai x1, x1, 1         # I15: FLUSHED (if mispredicted)
    j End
BranchFail:
    addi x30, x0, 1        # Dummy instruction
End:
    # --- 7. END OF PROGRAM --------------------------------------------------
    wfi                    # I16: Halt the processor.
